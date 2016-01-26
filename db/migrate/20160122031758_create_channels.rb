class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.references :user, index: true
      t.string :password
      t.string :setup_flow
      t.boolean :is_enable, default: false

      t.timestamps null: false
    end
    add_foreign_key :channels, :users
  end
end
