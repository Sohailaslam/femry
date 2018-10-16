class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :sort
  def index
    @tasks = current_user.tasks.order("task_date DESC").order(:sort).group_by(&:task_date)
  end

  def new
    @task = Task.new
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
  end

  def destroy
  end

  def sort
    params[:order].each do |key,value|
      Task.find(value[:id]).update_attribute(:sort,value[:position])
    end
    render plain: "OK"
  end
  private
  def task_params
    params[:task].permit(:title, :thought, :user_id)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
