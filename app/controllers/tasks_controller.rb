class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :sort

  before_action :set_task, only: [:update, :destroy]
  def index
    @tasks = current_user.tasks.order("task_date DESC").order(:sort).group_by(&:task_date)
  end

  def new
    @task = current_user.tasks.create!(task_date: params[:date])
    puts "CUREENTTTTTTTTTT", current_user.tasks.active_tasks.current_tasks(@task.task_date).count
  end

  def create
    @task = Task.new(task_params)
    if @task.save
    else
    end
  end

  def edit
  end

  def update
    @task.update(task_params) if @task.present?
    @task.update_streak if @task.status
  end

  def destroy
    @task.destroy if @task.present?
  end

  def sort
    params[:order].each do |key,value|
      Task.find(value[:id]).update_attribute(:sort,value[:position])
    end
    render plain: "OK"
  end
  private
  def task_params
    params[:task].permit(:status, :title, :thought, :user_id)
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end
end
