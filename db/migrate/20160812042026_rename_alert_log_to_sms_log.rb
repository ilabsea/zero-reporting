class RenameAlertLogToSmsLog < ActiveRecord::Migration
  def change
    rename_table :alert_logs, :sms_logs
  end
end
