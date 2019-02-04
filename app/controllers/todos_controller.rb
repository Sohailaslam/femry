class TodosController < ApplicationController
	before_action :authenticate_user!, only: [:index, :update]
	# skip_before_action :verify_authenticity_token, only: :update
  
  def index
  	require 'will_paginate/array'
    # current_user.incomplete_tasks if current_user.present?
    @user = current_user.present? ? current_user : User.find(3)
    @user.delete_inactive_todos
    puts "TIMEZONE"*50
    puts Time.now
    puts Time.current
    puts Time.current.in_time_zone(@user.get_timezone)

    @user.tasks.create(task_date: Time.current, status: false) unless @user.tasks.present?
    if params[:date].present?
      @grouped_tasks = @user.tasks.active_tasks.where("Date(task_date) = ?", Date.strptime(params[:date], "%Y-%m-%d").in_time_zone(@user.get_timezone).to_date)
      @grouped_tasks = @grouped_tasks.order("task_date DESC").order(:sort).group_by{|t| t.task_date.in_time_zone(@user.get_timezone).to_date}      
    else
      @grouped_tasks = @user.tasks.active_tasks.where(task_date: Time.current.in_time_zone(@user.get_timezone).to_date)
      @grouped_tasks = @user.tasks.active_tasks.order("task_date DESC").order(:sort).group_by{|t| t.task_date.in_time_zone(@user.get_timezone).to_date}
    # @grouped_tasks = @user.tasks.active_tasks.order("task_date DESC").order(:sort).group_by(&:task_date)
      unless @grouped_tasks.present?
        @grouped_tasks = {Time.current.in_time_zone(@user.get_timezone).to_date => []}.merge!(@grouped_tasks)
      end
    end
    @day_tasks = current_user.tasks.where("Date(task_date) = ? ", Date.strptime(params[:date], "%Y-%m-%d").in_time_zone(@user.get_timezone).to_date) if params[:date].present? 
    @grouped_tasks = @grouped_tasks.to_a.paginate(:page => 1, :per_page => (params[:page].present? ? params[:page].to_i : 1) * 14)
    if params[:date].present?
      render 'index.js'
    end
  end

  def update_deleted_column
    if params["button_type"] == 'task'
      @task = Task.find_by(id: params[:id])
      @task.update(is_deleted: (params["button_action"] == 'make_inactive') ? true : false) if @task.present?
    else
      @thought = Thought.find(params[:id])
      @thought.update(is_deleted: (params["button_action"] == 'make_inactive') ? true : false)
    end
  end

end
