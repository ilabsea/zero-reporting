class CreateOds < ActiveRecord::Migration
  def change
    create_table :ods do |t|
      t.string :name
      t.string :code
      t.references :phd, index: true

      t.timestamps null: false
    end
    add_foreign_key :ods, :phds
  end
end
