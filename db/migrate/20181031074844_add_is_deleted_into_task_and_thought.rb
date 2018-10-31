class AddIsDeletedIntoTaskAndThought < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :is_deleted, :boolean, default: false
    add_column :thoughts, :is_deleted, :boolean, default: false

  end
end
