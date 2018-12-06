class HomeController < ApplicationController
  def index
  end

  def public_feed
    @grouped_tasks = Task.includes(:user).where('users.public_task = ? AND is_deleted = ? AND status = ?', true, false, true).references(:user).order("task_date DESC").order(:sort).where.not(title: nil).where.not(title: '').group_by{|t| t.task_date.in_time_zone(current_user.present? ? current_user.get_timezone : Time.zone.name).to_date}
    unless @grouped_tasks.present?
      @grouped_tasks = {Time.current.in_time_zone(Time.zone.name).to_date => []}.merge!(@grouped_tasks)
    end
  end
end
