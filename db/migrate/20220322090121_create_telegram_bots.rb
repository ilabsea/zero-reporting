class CreateTelegramBots < ActiveRecord::Migration
  def change
    create_table :telegram_bots do |t|
      t.string  :token
      t.string  :username
      t.boolean :enabled, default: false
      t.boolean :actived, default: false

      t.timestamps null: false
    end
  end
end
