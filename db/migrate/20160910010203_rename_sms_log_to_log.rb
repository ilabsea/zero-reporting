class RenameSmsLogToLog < ActiveRecord::Migration
  def change
    rename_table :sms_logs, :logs
  end
end
