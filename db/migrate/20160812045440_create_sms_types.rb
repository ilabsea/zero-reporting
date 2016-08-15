class CreateSmsTypes < ActiveRecord::Migration
  def change
    create_table :sms_types do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps null: false
    end

    add_index :sms_types, :name, :unique => true
  end
end
