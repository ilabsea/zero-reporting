class RenameSmsTypeToLogType < ActiveRecord::Migration
  def change
    rename_table :sms_types, :log_types
  end
end
