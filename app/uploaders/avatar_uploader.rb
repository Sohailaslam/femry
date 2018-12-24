class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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
    manipulate! do |img|
      img = img.auto_orient
    end
  end
  # Create different versions of your uploaded files:
  version :thumb do
    process :auto_orient
    process :resize_to_fill => [50, 50]
    # process :custom_resize
  end
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
end
# http://ruby.bastardsbook.com/chapters/image-manipulation/
# https://blog.ethansteiner.com/uploading-images-and-processing-with-rmagick-348c7e47cb1e