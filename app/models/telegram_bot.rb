# == Schema Information
#
# Table name: telegram_bots
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  username   :string(255)
#  enabled    :boolean          default(FALSE)
#  actived    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TelegramBot < ActiveRecord::Base
  validates :token, :username, presence: true, if: :enabled?

  before_create :post_webhook_to_telegram
  before_update :post_webhook_to_telegram

  # Instance methods
  def post_webhook_to_telegram
    bot = Telegram::Bot::Client.new(token: token, username: username)

    begin
      request = bot.set_webhook(url: ENV["TELEGRAM_CALLBACK_URL"])

      self.actived = request["ok"]
    rescue
      self.actived = false
    end
  end

  # Class methods
  def self.send_message(chat_id, message)
    client.send_message(chat_id: chat_id, text: message, parse_mode: :HTML)
  end

  def self.instance
    @@instance ||= first || self.new
  end

  def self.client
    @@client ||= ::Telegram::Bot::Client.new(instance.token, instance.username)
  end
end
