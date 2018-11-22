class Task < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort
  belongs_to :user
  belongs_to :tag, optional: true
  scope :completed_tasks, ->{where(status: true )}
  scope :current_tasks, ->(key) {where("Date(task_date) = ?", key)}
  scope :active_tasks, -> {where(is_deleted: false)}
  scope :deleted_tasks, -> {where(is_deleted: true)}
  scope :weekly_tasks, -> (timezone) {where("task_date >= ?", Time.now.in_time_zone(timezone).weeks_ago(1).to_date)}
  scope :monthly_tasks, -> (timezone) {where("task_date >= ?", Time.now.in_time_zone(timezone).months_ago(1).to_date)}
  scope :date_range_tasks, -> (date_from, date_to) {where("Date(task_date) >= ? AND Date(task_date) <= ?", date_from, date_to)}
  
end
