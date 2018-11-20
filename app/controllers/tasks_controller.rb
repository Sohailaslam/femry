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
    if params[:task].present?
      tags = identify_tags(params[:task][:title].split(" ")) if params[:task][:title].include?("tag:")
      if tags.present?
        tags.each do |tag|
          Tag.find_or_create_by(user_id: current_user.id, title: tag)
        end
      end
      @task.update(task_params) if @task.present?
    end
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

  def identify_tags(title_array)
    title_tags = title_array.select{|title| title.include?("#")}
    tags = title_tags.map{|c| c.split("tag:").last.gsub(")", "")}
  end
end
