class ApplicationController < ActionController::Base 
	after_action :reset_limit
	def after_sign_in_path_for(resource)
  	if resource.is_admin?
  		admin_dashboard_index_path
    else
    	authenticated_root_path
    end
  end


  private
  def reset_limit
    current_user.update_attributes(last_renewed: current_user.last_renewed + 30.days) if current_user.present? && current_user.last_renewed < 30.days.ago
  end
end
