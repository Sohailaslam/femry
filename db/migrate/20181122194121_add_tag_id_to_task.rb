class AddTagIdToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :tag, foreign_key: true
  end
end
