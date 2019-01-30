module DeviseHelper
 

 #def devise_error_messages!
 # return '' if resource.errors.empty?

 #  messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

 #  html = <<-HTML
 #  <div class="alert alert-danger alert-block"> <button type="button"
 #   class="close" data-dismiss="alert">x</button>
 #   #{messages}
 #  </div>
 #  HTML

 #  html.html_safe
 #end
 
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <h4>#{sentence}</h4>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

	def all_country_zone_identifiers
 		[
		  ["(GMT-12) International Date Line West", "Etc/GMT+12"], 
		  ["(GMT-11) Midway Island", "Pacific/Midway"], 
		  ["(GMT-11) American Samoa", "Pacific/Pago_Pago"], 
		  ["(GMT-10) Hawaii", "Pacific/Honolulu"], 
		  ["(GMT-8) Alaska", "America/Juneau"], 
		  ["(GMT-7) Pacific Time (US & Canada)", "America/Los_Angeles"], 
		  ["(GMT-7) Tijuana", "America/Tijuana"], 
		  ["(GMT-7) Arizona", "America/Phoenix"], 
		  ["(GMT-7) Chihuahua", "America/Chihuahua"], 
		  ["(GMT-7) Mazatlan", "America/Mazatlan"], 
		  ["(GMT-6) Mountain Time (US & Canada)", "America/Denver"], 
		  ["(GMT-6) Saskatchewan", "America/Regina"], 
		  ["(GMT-6) Guadalajara", "America/Mexico_City"], 
		  ["(GMT-6) Mexico City", "America/Mexico_City"], 
		  ["(GMT-6) Monterrey", "America/Monterrey"], 
		  ["(GMT-6) Central America", "America/Guatemala"], 
		  ["(GMT-5) Central Time (US & Canada)", "America/Chicago"], 
		  ["(GMT-5) Bogota", "America/Bogota"], 
		  ["(GMT-5) Lima", "America/Lima"], 
		  ["(GMT-5) Quito", "America/Lima"], 
		  ["(GMT-4) Eastern Time (US & Canada)", "America/New_York"], 
		  ["(GMT-4) Indiana (East)", "America/Indiana/Indianapolis"], 
		  ["(GMT-4) Caracas", "America/Caracas"], 
		  ["(GMT-4) La Paz", "America/La_Paz"], 
		  ["(GMT-4) Georgetown", "America/Guyana"], 
		  ["(GMT-4) Puerto Rico", "America/Puerto_Rico"], 
		  ["(GMT-3) Atlantic Time (Canada)", "America/Halifax"], 
		  ["(GMT-3) Santiago", "America/Santiago"], 
		  ["(GMT-3) Newfoundland", "America/St_Johns"], 
		  ["(GMT-3) Brasilia", "America/Sao_Paulo"], 
		  ["(GMT-3) Buenos Aires", "America/Argentina/Buenos_Aires"], 
		  ["(GMT-3) Montevideo", "America/Montevideo"], 
		  ["(GMT-3) Greenland", "America/Godthab"], 
		  ["(GMT-2) Mid-Atlantic", "Atlantic/South_Georgia"], 
		  ["(GMT-1) Azores", "Atlantic/Azores"], 
		  ["(GMT-1) Cape Verde Is.", "Atlantic/Cape_Verde"], 
		  ["(GMT+0) Dublin", "Europe/Dublin"], 
		  ["(GMT+0) Edinburgh", "Europe/London"], 
		  ["(GMT+0) Lisbon", "Europe/Lisbon"], 
		  ["(GMT+0) London", "Europe/London"], 
		  ["(GMT+0) Casablanca", "Africa/Casablanca"], 
		  ["(GMT+0) Monrovia", "Africa/Monrovia"], 
		  ["(GMT+0) UTC", "Etc/UTC"], 
		  ["(GMT+1) Belgrade", "Europe/Belgrade"], 
		  ["(GMT+1) Bratislava", "Europe/Bratislava"], 
		  ["(GMT+1) Budapest", "Europe/Budapest"], 
		  ["(GMT+1) Ljubljana", "Europe/Ljubljana"], 
		  ["(GMT+1) Prague", "Europe/Prague"], 
		  ["(GMT+1) Sarajevo", "Europe/Sarajevo"], 
		  ["(GMT+1) Skopje", "Europe/Skopje"], 
		  ["(GMT+1) Warsaw", "Europe/Warsaw"], 
		  ["(GMT+1) Zagreb", "Europe/Zagreb"], 
		  ["(GMT+1) Brussels", "Europe/Brussels"], 
		  ["(GMT+1) Copenhagen", "Europe/Copenhagen"], 
		  ["(GMT+1) Madrid", "Europe/Madrid"], 
		  ["(GMT+1) Paris", "Europe/Paris"], 
		  ["(GMT+1) Amsterdam", "Europe/Amsterdam"], 
		  ["(GMT+1) Berlin", "Europe/Berlin"], 
		  ["(GMT+1) Bern", "Europe/Zurich"], 
		  ["(GMT+1) Zurich", "Europe/Zurich"], 
		  ["(GMT+1) Rome", "Europe/Rome"], 
		  ["(GMT+1) Stockholm", "Europe/Stockholm"], 
		  ["(GMT+1) Vienna", "Europe/Vienna"], 
		  ["(GMT+1) West Central Africa", "Africa/Algiers"], 
		  ["(GMT+2) Bucharest", "Europe/Bucharest"], 
		  ["(GMT+2) Cairo", "Africa/Cairo"], 
		  ["(GMT+2) Helsinki", "Europe/Helsinki"], 
		  ["(GMT+2) Kyiv", "Europe/Kiev"], 
		  ["(GMT+2) Riga", "Europe/Riga"], 
		  ["(GMT+2) Sofia", "Europe/Sofia"], 
		  ["(GMT+2) Tallinn", "Europe/Tallinn"], 
		  ["(GMT+2) Vilnius", "Europe/Vilnius"], 
		  ["(GMT+2) Athens", "Europe/Athens"], 
		  ["(GMT+2) Jerusalem", "Asia/Jerusalem"], 
		  ["(GMT+2) Harare", "Africa/Harare"], 
		  ["(GMT+2) Pretoria", "Africa/Johannesburg"], 
		  ["(GMT+2) Kaliningrad", "Europe/Kaliningrad"], 
		  ["(GMT+3) Istanbul", "Europe/Istanbul"], 
		  ["(GMT+3) Minsk", "Europe/Minsk"], 
		  ["(GMT+3) Moscow", "Europe/Moscow"], 
		  ["(GMT+3) St. Petersburg", "Europe/Moscow"], 
		  ["(GMT+3) Volgograd", "Europe/Volgograd"], 
		  ["(GMT+3) Kuwait", "Asia/Kuwait"], 
		  ["(GMT+3) Riyadh", "Asia/Riyadh"], 
		  ["(GMT+3) Nairobi", "Africa/Nairobi"], 
		  ["(GMT+3) Baghdad", "Asia/Baghdad"], 
		  ["(GMT+3) Tehran", "Asia/Tehran"], 
		  ["(GMT+4) Samara", "Europe/Samara"], 
		  ["(GMT+4) Abu Dhabi", "Asia/Muscat"], 
		  ["(GMT+4) Muscat", "Asia/Muscat"], 
		  ["(GMT+4) Baku", "Asia/Baku"], 
		  ["(GMT+4) Tbilisi", "Asia/Tbilisi"], 
		  ["(GMT+4) Yerevan", "Asia/Yerevan"], 
		  ["(GMT+4) Kabul", "Asia/Kabul"], 
		  ["(GMT+5) Ekaterinburg", "Asia/Yekaterinburg"], 
		  ["(GMT+5) Islamabad", "Asia/Karachi"], 
		  ["(GMT+5) Karachi", "Asia/Karachi"], 
		  ["(GMT+5) Tashkent", "Asia/Tashkent"], 
		  ["(GMT+5) Chennai", "Asia/Kolkata"], 
		  ["(GMT+5) Kolkata", "Asia/Kolkata"], 
		  ["(GMT+5) Mumbai", "Asia/Kolkata"], 
		  ["(GMT+5) New Delhi", "Asia/Kolkata"], 
		  ["(GMT+5) Kathmandu", "Asia/Kathmandu"], 
		  ["(GMT+5) Sri Jayawardenepura", "Asia/Colombo"], 
		  ["(GMT+6) Astana", "Asia/Dhaka"], 
		  ["(GMT+6) Dhaka", "Asia/Dhaka"], 
		  ["(GMT+6) Almaty", "Asia/Almaty"], 
		  ["(GMT+6) Rangoon", "Asia/Rangoon"], 
		  ["(GMT+6) Urumqi", "Asia/Urumqi"], 
		  ["(GMT+7) Novosibirsk", "Asia/Novosibirsk"], 
		  ["(GMT+7) Bangkok", "Asia/Bangkok"], 
		  ["(GMT+7) Hanoi", "Asia/Bangkok"], 
		  ["(GMT+7) Jakarta", "Asia/Jakarta"], 
		  ["(GMT+7) Krasnoyarsk", "Asia/Krasnoyarsk"], 
		  ["(GMT+8) Beijing", "Asia/Shanghai"], 
		  ["(GMT+8) Chongqing", "Asia/Chongqing"], 
		  ["(GMT+8) Hong Kong", "Asia/Hong_Kong"], 
		  ["(GMT+8) Kuala Lumpur", "Asia/Kuala_Lumpur"], 
		  ["(GMT+8) Singapore", "Asia/Singapore"], 
		  ["(GMT+8) Taipei", "Asia/Taipei"], 
		  ["(GMT+8) Perth", "Australia/Perth"], 
		  ["(GMT+8) Irkutsk", "Asia/Irkutsk"], 
		  ["(GMT+8) Ulaanbaatar", "Asia/Ulaanbaatar"], 
		  ["(GMT+9) Seoul", "Asia/Seoul"], 
		  ["(GMT+9) Osaka", "Asia/Tokyo"], 
		  ["(GMT+9) Sapporo", "Asia/Tokyo"], 
		  ["(GMT+9) Tokyo", "Asia/Tokyo"], 
		  ["(GMT+9) Yakutsk", "Asia/Yakutsk"], 
		  ["(GMT+9) Darwin", "Australia/Darwin"], 
		  ["(GMT+10) Adelaide", "Australia/Adelaide"], 
		  ["(GMT+10) Brisbane", "Australia/Brisbane"], 
		  ["(GMT+10) Guam", "Pacific/Guam"], 
		  ["(GMT+10) Vladivostok", "Asia/Vladivostok"], 
		  ["(GMT+10) Port Moresby", "Pacific/Port_Moresby"], 
		  ["(GMT+11) Canberra", "Australia/Melbourne"], 
		  ["(GMT+11) Melbourne", "Australia/Melbourne"], 
		  ["(GMT+11) Sydney", "Australia/Sydney"], 
		  ["(GMT+11) Hobart", "Australia/Hobart"], 
		  ["(GMT+11) Magadan", "Asia/Magadan"], 
		  ["(GMT+11) Srednekolymsk", "Asia/Srednekolymsk"], 
		  ["(GMT+11) Solomon Is.", "Pacific/Guadalcanal"], 
		  ["(GMT+11) New Caledonia", "Pacific/Noumea"], 
		  ["(GMT+12) Fiji", "Pacific/Fiji"], 
		  ["(GMT+12) Kamchatka", "Asia/Kamchatka"], 
		  ["(GMT+12) Marshall Is.", "Pacific/Majuro"], 
		  ["(GMT+13) Auckland", "Pacific/Auckland"], 
		  ["(GMT+13) Wellington", "Pacific/Auckland"], 
		  ["(GMT+13) Nuku'alofa", "Pacific/Tongatapu"], 
		  ["(GMT+13) Tokelau Is.", "Pacific/Fakaofo"], 
		  ["(GMT+13) Chatham Is.", "Pacific/Chatham"], 
		  ["(GMT+14) Samoa", "Pacific/Apia"]
	]
 	end
end

