# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  # Todo: update this
  # before_filter :authorize_ip_address
  before_filter :set_locale

  def start!(word=nil, *other_words)
    sms = I18n.t('telegram_bot.welcome_message', username: chat["first_name"])

    send_message(chat["id"], sms)
  end

  # /associate 011222333 120101
  # /associate 011222333 place_name
  def associate!(phone_number = nil, *place)
    user = User.find_by_phone_and_place(phone_number, place.join(' '))
    sms = I18n.t("telegram_bot.invalid_info_message", username: chat["first_name"])

    if user.present?
      user.update(telegram_chat_id: chat["id"], telegram_username: chat["first_name"])
      sms = I18n.t("telegram_bot.congratulation_message", username: chat["first_name"], place: user.place.display_name)
    end

    send_message(chat["id"], sms)
  end

  private
    def send_message(chat_id, sms)
      ::TelegramBot.send_message(chat_id, sms)
    end

    def set_locale
      I18n.locale = 'km'
    end
end
