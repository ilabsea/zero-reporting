class CreateAlertLogs < ActiveRecord::Migration
  def change
    create_table :alert_logs do |t|
      t.string :from
      t.string :to
      t.string :body
      t.string :suggested_channel
      t.integer :verboice_project_id

      t.timestamps null: false
    end
  end
end
