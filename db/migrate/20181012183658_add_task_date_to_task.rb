class AddTaskDateToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :task_date, :date
  end
end
