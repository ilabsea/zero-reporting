class CreateReportReviewedSettings < ActiveRecord::Migration
  def change
    create_table :report_reviewed_settings do |t|
      t.string :endpoint
      t.string :username
      t.string :password
      t.integer :verboice_project_id

      t.timestamps null: false
    end
  end
end
