class RemoveUserFromAlert < ActiveRecord::Migration
  def change
    remove_column :alerts, :user_id
  end
end
