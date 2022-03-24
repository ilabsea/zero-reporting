class TelegramQueueJob < ActiveJob::Base
  queue_as ENV['DEFAULT_QUEUE_NAME']

  def perform(option={})
    user = User.find option[:user_id]

    return unless user.telegram_chat_id.present?

    TelegramBot.send_message(user.telegram_chat_id, option[:message])
  end
end
