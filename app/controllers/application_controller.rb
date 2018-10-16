class ApplicationController < ActionController::Base 

	def after_sign_in_path_for(resource)
		flash[:notice] = 'Signed in Successfully'
	    new_user_path
	  end
end
