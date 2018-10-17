class Admin::DashboardController < ApplicationController
	before_action :authenticate_user!
	before_action :validate_admin
  def index
  	@users = User.includes(:tasks).all.order('created_at DESC')
  end


  private 
  def validate_admin
  	if current_user.is_admin == false
  		redirect_to root_path, alert: "You are not permitted to access this Url"
  	end
  end
end
