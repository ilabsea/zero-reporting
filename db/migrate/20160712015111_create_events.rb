class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :description
      t.date :from_date
      t.date :to_date

      t.timestamps null: false
    end
  end
end
