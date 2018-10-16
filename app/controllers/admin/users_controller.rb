class Admin::UsersController < Admin::DashboardController
	before_action :set_user

	def edit
	end

	def update
		if @user.update(user_params)
		else
		end
	end

	private
	def set_user
		@user = User.find(params[:id])
	end

	 def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
