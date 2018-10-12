class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks.order("task_date DESC").group_by(&:task_date)
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

  private
  def task_params
    params[:task].permit(:title, :thought, :user_id)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
