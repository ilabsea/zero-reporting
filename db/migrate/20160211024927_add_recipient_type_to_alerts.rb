class AddRecipientTypeToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :recipient_type, :text
  end
end
