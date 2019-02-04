class AddPlanToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :plan, foreign_key: true, default: 1
    add_column :users, :last_renewed, :datetime
    add_column :users, :status, :integer
  end
end
