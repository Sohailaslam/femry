class ChangeColumnTaskDate < ActiveRecord::Migration[5.2]
  def self.up
  	change_column :tasks, :task_date, :datetime
  end

  def self.down
  	change_column :tasks, :task_date, :date
  end
end
