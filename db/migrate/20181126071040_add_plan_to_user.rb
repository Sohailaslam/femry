class AddPlanToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :plan, foreign_key: true
    add_column :users, :last_renenwed, :datetime
    add_column :users, :status, :integer
  end
end
