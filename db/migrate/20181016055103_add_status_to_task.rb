class AddStatusToTask < ActiveRecord::Migration[5.2]
  def change
  	remove_column :tasks, :status, :string
  	add_column :tasks, :status, :boolean, default: false
  end
end
