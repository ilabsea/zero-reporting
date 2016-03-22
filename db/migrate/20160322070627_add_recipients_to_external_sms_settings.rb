class AddRecipientsToExternalSmsSettings < ActiveRecord::Migration
  def change
    add_column :external_sms_settings, :recipients, :string, array: true, default: []
  end
end
