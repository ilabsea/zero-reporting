class AddVerboiceSyncFailedCountToReports < ActiveRecord::Migration
  def change
    add_column :reports, :verboice_sync_failed_count, :integer, default: 0

    add_index :reports, [:call_log_id, :verboice_sync_failed_count, :status], name: 'index_call_failed_status'
  end
end
