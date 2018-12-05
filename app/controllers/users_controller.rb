class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :update]
  skip_before_action :verify_authenticity_token, only: :update
  before_action :set_user, only: :update


  def new
  	require 'will_paginate/array'
    current_user.incomplete_tasks if current_user.present?
    @user = current_user.present? ? current_user : User.find(3)
    @user.tasks.create(task_date: Time.current.in_time_zone(@user.timezone).to_date, status: false) unless @user.tasks.present?
    @grouped_tasks = @user.tasks.where(task_date: Time.current.in_time_zone(@user.timezone).to_date)
    
    @grouped_tasks = @user.tasks.order("task_date DESC").order(:sort).group_by{|t| t.task_date.to_date}
    unless @grouped_tasks.present?
      @grouped_tasks = {Time.current.in_time_zone(@user.timezone).to_date => []}.merge!(@grouped_tasks)
    end    
    @grouped_tasks = @grouped_tasks.to_a.paginate(:page => 1, :per_page => (params[:page].present? ? params[:page].to_i : 1) * 14)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update	
    require 'will_paginate/array'
    @user.update(user_params)
    @grouped_tasks = @user.tasks.order("DATE(task_date) DESC").order(:sort).group_by{|t| t.task_date.to_date}
    @grouped_tasks = @grouped_tasks.to_a.paginate(:page => 1, :per_page => (params[:page].present? ? params[:page].to_i : 1) * 14)
  end

  def aws_auth
    user_id = params[:user_id].present? ? params[:user_id] : session[:aws_auth_user_id]
    @user = User.find(user_id)
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
			redirect_to root_path, notice: "Please add your to-do’s at the bottom"
    rescue => e
      redirect_to aws_auth_path, notice: e.message
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

  def stats
    @user = User.find(params[:user_id])
    @completed_tasks_today = @user.tasks.active_tasks.current_tasks(Time.current.in_time_zone(@user.timezone).to_date).completed_tasks.count
    @completed_tasks_week = @user.tasks.active_tasks.weekly_tasks(@user.timezone).completed_tasks.count
    @completed_tasks_month = @user.tasks.active_tasks.monthly_tasks(@user.timezone).completed_tasks.count
    @completed_tasks_total = @user.tasks.active_tasks.completed_tasks.count
    if params["daterange"].present?
      from_date = params["daterange"].split(' - ').first.to_date
      to_date = params["daterange"].split(' - ').last.to_date
      @date_from = from_date
      @date_to = to_date
      @completed_range_tasks = @user.tasks.active_tasks.date_range_tasks(@date_from, @date_to).completed_tasks.count
    else
      @date_from = Time.current.in_time_zone(@user.timezone)-29.days
      @date_to = Time.current.in_time_zone(@user.timezone)
    end

  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, tasks_attributes: [:id, :title, :status, :task_date, :_destroy], thoughts_attributes: [:id, :title, :thought_date, :_destroy])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
