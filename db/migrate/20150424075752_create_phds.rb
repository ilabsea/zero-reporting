class CreatePhds < ActiveRecord::Migration
  def change
    create_table :phds do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end
  end
end
