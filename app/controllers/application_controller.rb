class ApplicationController < ActionController::Base 
	after_action :reset_limit, if: :current_user
  around_action :user_time_zone, if: :current_user

  def user_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end
  
	def after_sign_in_path_for(resource)
  	if resource.is_admin?
  		admin_dashboard_index_path
    else
    	authenticated_root_path
    end
  end


  private
  def reset_limit
    if current_user.last_renewed.present?
      current_user.update_attributes(last_renewed: current_user.last_renewed + 30.days) if current_user.present? && current_user.last_renewed < 30.days.ago
    else
      current_user.update_attributes(last_renewed: Date.today)
    end
  end
end
