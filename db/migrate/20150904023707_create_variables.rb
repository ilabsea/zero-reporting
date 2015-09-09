class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :name
      t.string :description

      t.integer :verboice_id
      t.string :verboice_name

      t.integer :verboice_project_id

      t.timestamps null: false
    end
  end
end
