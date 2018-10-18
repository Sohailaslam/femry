class ApplicationController < ActionController::Base 

	def after_sign_in_path_for(resource)
  	if resource.is_admin?
  		admin_dashboard_index_path
    else
    	authenticated_root_path
    end
  end
end
