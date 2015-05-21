class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :phone_number
      t.references :user, index: true
      t.string :audio
      t.boolean :listened
      t.datetime :called_at
      t.integer :call_log_id

      t.timestamps null: false
    end
    add_foreign_key :reports, :users
  end
end
