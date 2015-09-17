class AddPhdIdAndOdIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phd_id, :integer
    add_column :users, :od_id, :integer
  end
end
