class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :update]
  skip_before_action :verify_authenticity_token, only: :update
  before_action :set_user, only: :update

  def new
    current_user.incomplete_tasks if current_user.present?
    @user = current_user.present? ? current_user : User.find(3) 
  end

  def update	
    @user.update(user_params)
  end

  def aws_auth
    @user = User.find(params[:user_id])
  end

	def password_auth
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
			sign_in(:user, @user)
			redirect_to root_path, notice: "Account Authenticated Successfully"
      # sign_in(@user, scope: :user)
    rescue => e
      redirect_to aws_auth_path(@user.id), notice: e.message
    end
  end

	def validate_password_reset_code
		@user = User.find(params[:user_id])
		client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
		begin
			resp = client.confirm_forgot_password({
  				client_id: ENV["AWS_COGNITO_CLIENT_ID"],
  				username: @user.email, # required
  				confirmation_code: params["verify_code"],
  				password: params["new_password"],
			})
			if @user.update(password: params["new_password"])
				redirect_to root_path, notice: "Password Changed Successfully"
			else
				redirect_to password_auth_path(@user.id), notice: @user.errors.full_messages
			end
		rescue => e
			redirect_to password_auth_path(@user.id), notice: e.message
		end
	end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, tasks_attributes: [:id, :title, :status, :task_date, :_destroy], thoughts_attributes: [:id, :title, :task_date, :_destroy])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
