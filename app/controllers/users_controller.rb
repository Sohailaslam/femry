class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update
	before_action :set_user, only: :update


	def new
	  @user = current_user
	 end

	def update
	  @user.update(user_params)
	end

	def aws_auth
		@user = User.find(params[:user_id])
	end

	def validate_code
		@user = User.find(params[:user_id])
		client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
		begin
			client.confirm_sign_up({
		  	client_id: ENV["AWS_COGNITO_CLIENT_ID"],
		  	username: @user.email, # required
		  	confirmation_code: params["verify_code"],
		  	force_alias_creation: false,
			})
			redirect_to root_path, notice: "Account Authenticated Successfully"
      # sign_in(@user, scope: :user)
		rescue => e
			redirect_to aws_auth_path(@user.id), notice: e.message
		end
	end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, tasks_attributes: [:id, :title, :status, :task_date, :_destroy])
  end

  def set_user
  	@user = User.find(params[:id])
  end
end
