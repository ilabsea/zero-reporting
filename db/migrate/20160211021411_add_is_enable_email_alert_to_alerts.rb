class AddIsEnableEmailAlertToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :is_enable_email_alert, :boolean, default: false
  end
end
