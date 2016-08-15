class AddTypeToSmsLog < ActiveRecord::Migration
  def change
    add_reference :sms_logs, :type, index: true
    # add_foreign_key :sms_logs, :sms_types
  end
end
