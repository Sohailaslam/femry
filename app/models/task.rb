class Task < ApplicationRecord
	include RailsSortable::Model
  set_sortable :sort
  belongs_to :user
end
