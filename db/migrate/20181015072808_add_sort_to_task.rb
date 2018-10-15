class AddSortToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :sort, :integer
  end
end
