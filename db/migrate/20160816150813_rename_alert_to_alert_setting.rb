class RenameAlertToAlertSetting < ActiveRecord::Migration
  def change
    rename_table :alerts, :alert_settings
  end
end
