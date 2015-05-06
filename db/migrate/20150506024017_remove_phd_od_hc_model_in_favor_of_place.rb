class RemovePhdOdHcModelInFavorOfPlace < ActiveRecord::Migration
  def up
    drop_table :members
    drop_table :ods
    drop_table :phds
  end

  def down
    create_table :phds do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end

    create_table :ods do |t|
      t.string :name
      t.string :code
      t.references :phd, index: true

      t.timestamps null: false
    end
    add_foreign_key :ods, :phds


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
