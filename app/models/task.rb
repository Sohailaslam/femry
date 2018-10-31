class Task < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort
  belongs_to :user

  scope :completed_tasks, ->{where(status: true )}
  scope :current_tasks, ->(key) {where(task_date: key)}
  scope :active_tasks, -> {where(is_deleted: false)}
  scope :deleted_tasks, -> {where(is_deleted: true)}
  
end
