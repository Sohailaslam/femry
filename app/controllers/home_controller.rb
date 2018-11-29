class HomeController < ApplicationController
  def index
  end

  def public_feed
    @grouped_tasks = Task.includes(:user).where('users.public_task = ? AND is_deleted = ? AND status = ?', true, false, true).references(:user).order("task_date DESC").order(:sort).where.not(title: nil).group_by(&:task_date)
    unless @grouped_tasks.present?
      @grouped_tasks = {Time.now.in_time_zone(Time.zone.name).to_date => []}.merge!(@grouped_tasks)
    end
  end
end
