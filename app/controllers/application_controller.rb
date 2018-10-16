class ApplicationController < ActionController::Base 

	def after_sign_in_path_for(resource)
		flash[:notice] = 'Signed in Successfully'
  	if resource.is_admin?
  		admin_dashboard_index_path
    else
    	new_user_path
    end
  end
end
