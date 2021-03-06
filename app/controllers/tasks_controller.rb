class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :sort

  before_action :set_task, only: [:update, :destroy, :edit]
  def index
    @tasks = current_user.tasks.order("task_date DESC").order(:sort).group_by(&:task_date)
  end

  def new
    @task = current_user.tasks.create!(task_date: params[:date].in_time_zone(current_user.get_timezone))
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
    if params[:task].present? && params[:task][:title].present?
      if params[:task][:title].include?("tag:")
        current_tags = current_user.tags.present? ? current_user.tags.map(&:title) : []
        last_tag = identify_last_tag(params[:task][:title].split(" "))
        last_tag = sanitize_title_str(last_tag)
        new_tag = if current_tags.present? && current_tags.include?(last_tag)
          nil
        else
          last_tag
        end
        
        params[:task][:title].gsub!(")", ") ") if params[:task][:title].include?(")")
        tag = params[:task][:title].split(" ").select{|c| c.include?("tag:")}.last
        params[:task][:title] = params[:task][:title] + " " + tag
        params[:task][:title].gsub!(")[#", ") [#") if params[:task][:title].include?(")[#")
        tag_index = params[:task][:title].split(" ").find_index(tag)
        title = params[:task][:title].split(" ")
        title.delete_at(tag_index)
        params[:task][:title] = title.join(" ") + "   "
        if new_tag.present? 
          @tag = current_user.tags.find_or_create_by(user_id: current_user.id, title: new_tag)
        else
          @tag = current_user.tags.find_by_title(last_tag)
        end
        @day_tasks = current_user.tasks.where("Date(task_date) = ? ", @task.task_date_converted)
        params[:task].merge!(tag_id: @tag.id)
      end
    end
    if params[:task][:status].present?
      params[:task].merge!(completed_at: DateTime.current)
    end

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
    params[:task].permit(:status, :title, :completed_at, :thought, :user_id, :tag_id)
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def identify_last_tag(title_array)
    params[:task][:title].split(" ").select{|c| c.include?("tag:")}.last
  end

  def sanitize_title(title_array, tags)
    tag_count = 1
    title_string = []
    title_array.each_with_index do |title, index|
      if title.include?("tag:")
        title_string << "#"+ sanitize_title_str(tags.select{|c| title.include?(c)}.first)
        tag_count+=1
      else
        title_string << title
      end
    end
    params[:task][:title] = title_string.join(" ")
  end

  def sanitize_title_str(title)
    title.split("tag:").last.gsub(")", "")
  end
end
