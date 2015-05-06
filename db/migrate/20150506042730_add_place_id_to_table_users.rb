class AddPlaceIdToTableUsers < ActiveRecord::Migration
  def change
    add_reference :users, :place, index: true
    add_foreign_key :users, :places
  end
end
