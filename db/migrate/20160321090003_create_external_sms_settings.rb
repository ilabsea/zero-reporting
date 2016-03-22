class CreateExternalSmsSettings < ActiveRecord::Migration
  def change
    create_table :external_sms_settings do |t|
      t.boolean :is_enable
      t.string :message_template
      t.integer :verboice_project_id

      t.timestamps null: false
    end
  end
end
