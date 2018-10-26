module ApplicationHelper


	def display_date(key)
		if key.to_date == Date.today
			"<b>Today,</b> ".html_safe + key.strftime("%B #{key.day}")
		elsif key.to_date == Date.today - 1
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

	def completed_percentage(f, key, user)
		if f.present?
			today_task = f.object.tasks.present? ? f.object.tasks.where(task_date: key) : 0
		else
			today_task = user.tasks.present? ? user.tasks.where(task_date: key) : 0
		end
		today_task.present? ? ((today_task.where(status: true).count.to_f/today_task.count.to_f) * 100).to_i : "0/0"
	end

	def completed_status(f, key, user)
		today_task = f.present? ? f.object.tasks.where(task_date: key) : user.tasks.where(task_date: key)
		completed = today_task.where(status: true)
		today_task.present? ? completed.present? ? "#{completed.count}/#{today_task.count}" : "0/#{today_task.count}" : 0
	end

	def get_date_keys(grouped_tasks)
		keys = @grouped_tasks.map{|c| c[0]}
		keys.include?(Date.today) ? keys : keys.insert(0, Date.today)
	end
end
