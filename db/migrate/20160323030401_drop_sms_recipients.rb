class DropSmsRecipients < ActiveRecord::Migration
  def change
    drop_table :sms_recipients
  end
end
