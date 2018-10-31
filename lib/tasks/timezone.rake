namespace :timezone do

  desc 'Adding user for site login'
  task :generate_timezone => :environment do
    new_timezones = []
    timezones = ActiveSupport::TimeZone::MAPPING
    # Time.now.in_time_zone('Asia/Karachi').gmt_offset/3600
    timezones.each do |timezone|
      seconds = Time.now.in_time_zone(timezone[1]).gmt_offset
      gmt_offset = Time.at(seconds).utc.strftime("%H:%M")
      new_timezones << ["(GMT#{gmt_offset}) "+timezone[0], timezone[1]]
    end
  end
end

