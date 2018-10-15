module ApplicationHelper


	def display_date(key)
		if key.to_date == Date.today
			"Today"
		elsif key.to_date == Date.today - 1
			"Yesterday"
		else
			key.strftime('%a %d %b %Y') 
		end
	end
end
