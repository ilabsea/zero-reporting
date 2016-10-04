class AddColumnStartedAtToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :started_at, :datetime, default: nil
  end
end
