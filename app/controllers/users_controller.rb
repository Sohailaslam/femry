class UsersController < ApplicationController
	before_action :set_user, only: :update
  def new
  	@user = current_user
  end

  def update
  	@user.update(user_params)
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, tasks_attributes: [:id, :title, :status, :task_date, :_destroy])
  end

  def set_user
  	@user = User.find(params[:id])
  end
end
