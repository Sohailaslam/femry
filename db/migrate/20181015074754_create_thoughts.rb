class CreateThoughts < ActiveRecord::Migration[5.2]
  def change
    create_table :thoughts do |t|
      t.text :title
      t.references :user, foreign_key: true
      t.date :thought_date

      t.timestamps
    end
  end
end
