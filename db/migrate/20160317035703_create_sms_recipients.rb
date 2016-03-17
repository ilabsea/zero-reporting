class CreateSmsRecipients < ActiveRecord::Migration
  def change
    create_table :sms_recipients do |t|
      t.string :name
      t.string :phone

      t.timestamps null: false
    end
  end
end
