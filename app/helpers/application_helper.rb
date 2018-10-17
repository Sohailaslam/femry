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

	def flash_class(level)
    case level
        when 'notice' then "alert alert-dismissable alert-info"
        when 'success' then "alert alert-dismissable alert-success"
        when 'error' then "alert alert-dismissable alert-danger"
        when 'alert' then "alert alert-dismissable alert-danger"
    end
	end

	def completed_percentage(f)
		today_task = f.object.tasks.where(task_date: Date.today)
		((today_task.where(status: true).count.to_f/today_task.count.to_f) * 100).to_i
	end

	def completed_status(f)
		today_task = f.object.tasks.where(task_date: Date.today)
		completed = today_task.where(status: true)
		today_task.present? ? completed.present? ? "#{completed.count}/#{today_task.count}" : "0/#{today_task.count}" : 0
	end
end
