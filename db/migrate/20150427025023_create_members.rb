class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :phone
      t.references :od, index: true
      t.references :phd, index: true

      t.timestamps null: false
    end
    add_foreign_key :members, :ods
    add_foreign_key :members, :phds
  end
end
