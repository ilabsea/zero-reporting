class RenameIsEnableToIsEnableSmsAlertInAlerts < ActiveRecord::Migration
  def change
    rename_column :alerts, :is_enable, :is_enable_sms_alert
  end
end
