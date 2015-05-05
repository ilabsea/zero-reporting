class AddAncestryToPlace < ActiveRecord::Migration
  def change
    add_column :places, :ancestry, :string
    add_index :places, :ancestry
  end
end
