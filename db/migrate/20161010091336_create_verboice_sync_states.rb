class CreateVerboiceSyncStates < ActiveRecord::Migration
  def change
    create_table :verboice_sync_states do |t|
      t.integer :last_call_log_id, default: -1

      t.timestamps null: false
    end
  end
end
