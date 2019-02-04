class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :title
      t.integer :total_tasks

      t.timestamps
    end
  end
end
