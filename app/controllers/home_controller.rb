class HomeController < ApplicationController
  def index
  end

  def public_feed
  	# User.includes(:tasks).where('tasks.is_deleted = ? AND tasks.status = ?', false, true).order('tasks.task_date DESC').order('tasks.sort').references(:tasks)
    # @grouped_tasks = Task.active_tasks.completed_tasks.order("task_date DESC").order(:sort).group_by(&:task_date)
    @grouped_tasks = Task.includes(:user).where('users.public_task = ? AND is_deleted = ? AND status = ?', true, false, true).references(:user).order("task_date DESC").order(:sort).group_by(&:task_date)
    unless @grouped_tasks.present?
      @grouped_tasks = {Time.now.in_time_zone(Time.zone.name).to_date => []}.merge!(@grouped_tasks)
    end
  end
end
