class AddPublicTaskToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :public_task, :boolean, default: true
  end
end
