class AddStreakinUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :streak_start, :datetime
    add_column :users, :streak_end, :datetime
  end
end
