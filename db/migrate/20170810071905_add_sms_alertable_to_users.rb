class AddSmsAlertableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_alertable, :boolean, default: true
    add_column :users, :disable_alert_reason, :string
  end
end
