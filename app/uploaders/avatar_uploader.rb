class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
 include CarrierWave::ImageOptimizer

  # Choose what kind of storage to use for this uploader:
  storage :fog
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    '/tmp/femry-cache'
  end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  def auto_orient
    # debugger
    manipulate! do |img, index, options|
      # options[:write] = {
      #   :quality => 100,
      #   :depth => 8
      # }
      img = img.auto_orient
    end
  end
  # Create different versions of your uploaded files:
  version :thumb do
    process :auto_orient
    process :resize_to_fit => [50, 50]
    # process :custom_resize
  end
  # process :quality => 100
  process :auto_orient

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # def custom_resize(width= 40, height= 40)
  #   current_path = self.file.file
  #   rmagick_image = ::Magick::Image.read(current_path).first
  #   if (rmagick_image.columns <= width && rmagick_image.rows <= height)
  #     white_fill = Magick::GradientFill.new(0, 0, 0, 0, "#FFF", "#FFF")
  #     dst = Magick::Image.new(width, height, white_fill)
  #     result = dst.composite(rmagick_image, Magick::CenterGravity, Magick::OverCompositeOp)
  #     result.write(current_path)
  #   else
  #     # self.resize_to_fill(width, height, gravity = ::Magick::CenterGravity)
  #     self.resize_to_limit(width, height)
  #     self.resize_and_pad(width, height, background = :transparent, gravity = ::Magick::CenterGravity)
  #   end
  # end

  def resize_with_crop(w, h, options = {})
    gravity = options[:gravity] || :center

    w_original, h_original = [img[:width].to_f, img[:height].to_f]

    op_resize = ''

    # check proportions
    if w_original * h < h_original * w
      op_resize = "#{w.to_i}x"
      w_result = w
      h_result = (h_original * w / w_original)
    else
      op_resize = "x#{h.to_i}"
      w_result = (w_original * h / h_original)
      h_result = h
    end

    w_offset, h_offset = crop_offsets_by_gravity(gravity, [w_result, h_result], [ w, h])

    img.combine_options do |i|
      i.resize(op_resize)
      i.gravity(gravity)
      i.crop "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"
    end

    img
  end

  # from http://www.dweebd.com/ruby/resizing-and-cropping-images-to-fixed-dimensions/

  GRAVITY_TYPES = [ :north_west, :north, :north_east, :east, :south_east, :south, :south_west, :west, :center ]

  def crop_offsets_by_gravity(gravity, original_dimensions, cropped_dimensions)
    raise(ArgumentError, "Gravity must be one of #{GRAVITY_TYPES.inspect}") unless GRAVITY_TYPES.include?(gravity.to_sym)
    raise(ArgumentError, "Original dimensions must be supplied as a [ width, height ] array") unless original_dimensions.kind_of?(Enumerable) && original_dimensions.size == 2
    raise(ArgumentError, "Cropped dimensions must be supplied as a [ width, height ] array") unless cropped_dimensions.kind_of?(Enumerable) && cropped_dimensions.size == 2

    original_width, original_height = original_dimensions
    cropped_width, cropped_height = cropped_dimensions

    vertical_offset = case gravity
      when :north_west, :north, :north_east then 0
      when :center, :east, :west then [ ((original_height - cropped_height) / 2.0).to_i, 0 ].max
      when :south_west, :south, :south_east then (original_height - cropped_height).to_i
    end

    horizontal_offset = case gravity
      when :north_west, :west, :south_west then 0
      when :center, :north, :south then [ ((original_width - cropped_width) / 2.0).to_i, 0 ].max
      when :north_east, :east, :south_east then (original_width - cropped_width).to_i
    end

    return [ horizontal_offset, vertical_offset ]
  end
end
# http://ruby.bastardsbook.com/chapters/image-manipulation/
# https://blog.ethansteiner.com/uploading-images-and-processing-with-rmagick-348c7e47cb1e