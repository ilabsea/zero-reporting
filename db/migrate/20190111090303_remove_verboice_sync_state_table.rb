class RemoveVerboiceSyncStateTable < ActiveRecord::Migration
  def change
    drop_table :verboice_sync_states
  end
end
