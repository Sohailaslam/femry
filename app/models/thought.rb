class Thought < ApplicationRecord
  belongs_to :user
  scope :active_thoughts, -> {where(is_deleted: false)}
  scope :deleted_thoughts, -> {where(is_deleted: true)}
end
