class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :code
      t.string :kind_of

      t.timestamps null: false
    end
  end
end
