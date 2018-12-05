class Task < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort
  belongs_to :user
  belongs_to :tag, optional: true

  after_create :update_streak

  scope :completed_tasks, ->{where(status: true )}
  scope :current_tasks, ->(key) {where("Date(task_date) = ?", key)}
  scope :active_tasks, -> {where(is_deleted: false)}
  scope :deleted_tasks, -> {where(is_deleted: true)}
  scope :weekly_tasks, -> (timezone) {where("Date(task_date) >= ?", Time.current.in_time_zone(timezone).weeks_ago(1).to_date)}
  scope :monthly_tasks, -> (timezone) {where("Date(task_date) >= ?", Time.current.in_time_zone(timezone).months_ago(1).to_date)}
  scope :date_range_tasks, -> (date_from, date_to) {where("Date(task_date) >= ? AND Date(task_date) <= ?", date_from, date_to)}
  

  def update_streak
    self.user.touch(:streak_start) unless self.user.streak_end.present? && self.user.streak_end > 24.hours.ago
    self.user.touch(:streak_end)
  end

  def task_date_converted
    self.task_date.to_date
  end

end
