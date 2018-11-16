module ApplicationHelper
	def local_date timezone
		Time.now.in_time_zone(timezone).to_date
	end

	def display_date(key, date)
		if key.to_date == date
			"<b>Today,</b> ".html_safe + key.strftime("%B #{key.day}")
		elsif key.to_date == date - 1
			"<b>Yesterday,</b> ".html_safe + key.strftime("%B #{key.day}")
		else
			"<b>#{key.strftime('%A')},</b> ".html_safe + key.strftime("%B #{key.day.ordinalize}")
		end
	end

	def flash_class(level)
    case level
        when 'notice' then "alert alert-dismissable alert-info"
        when 'success' then "alert alert-dismissable alert-success"
        when 'error' then "alert alert-dismissable alert-danger"
        when 'alert' then "alert alert-dismissable alert-danger"
    end
	end

	def completed_percentage(today_task, completed)
		today_task.present? ? ((completed.count.to_f/today_task.count.to_f) * 100).to_i : "0/0"
	end

	def completed_status(today_task, completed)
		today_task.present? ? completed.present? ? "#{completed.count}/#{today_task.count}" : "0/#{today_task.count}" : 0
	end

	def get_date_keys(grouped_tasks, date)
		keys = @grouped_tasks.map{|c| c[0]}
		keys.include?(date) ? keys : keys.insert(0, date)
	end

	def today_task(f, key, user)
		user.tasks.present? ? user.tasks.current_tasks(key).active_tasks : 0
	end

	def avatar_url(user)
	  if user.avatar.attached?
	    user.avatar.variant(resize: "45x45")
	  else
	    # default_url = "#{root_url}images/logo.jpg"
	    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
	    "https://gravatar.com/avatar/#{gravatar_id}.png?s=20"
	  end
	end
end
