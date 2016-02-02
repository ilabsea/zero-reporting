class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.boolean :is_enable
      t.string :message_template
      t.integer :user_id, belongs_to: :users
    end
  end
end
