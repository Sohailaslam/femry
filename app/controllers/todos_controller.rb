class TodosController < ApplicationController
	before_action :authenticate_user!, only: [:index, :update]
	# skip_before_action :verify_authenticity_token, only: :update
  
  def index
  	require 'will_paginate/array'
    # current_user.incomplete_tasks if current_user.present?
    @user = current_user.present? ? current_user : User.find(3)
    @user.tasks.create(task_date: Time.now.in_time_zone(@user.timezone).to_date, status: false) unless @user.tasks.present?
    @grouped_tasks = @user.tasks.where(task_date: Time.now.in_time_zone(@user.timezone).to_date)
    
    @grouped_tasks = @user.tasks.order("task_date DESC").order(:sort).group_by(&:task_date)
    unless @grouped_tasks.present?
      @grouped_tasks = {Time.now.in_time_zone(@user.timezone).to_date => []}.merge!(@grouped_tasks)
    end    
    @grouped_tasks = @grouped_tasks.to_a.paginate(:page => 1, :per_page => (params[:page].present? ? params[:page].to_i : 1) * 14)
  end
end
