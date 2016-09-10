class UpdateColumnLogsToToText < ActiveRecord::Migration
  def change
    change_column :logs, :to, :text, default: nil
  end
end
