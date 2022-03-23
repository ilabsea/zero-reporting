class AddTelegramChatIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :telegram_chat_id, :string
    add_column :users, :telegram_username, :string
  end
end
