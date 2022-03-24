require "rails_helper"
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramWebhooksController, telegram_bot: :rails do
  let(:chat) { { "id"=> '123', 'first_name' => 'Sokly'} }

  before {
    I18n.locale = :km
  }

  describe '#start!' do
    let(:welcome_sms) { I18n.t('telegram_bot.welcome_message', username: chat['first_name']) }

    it 'response with welcome message' do
      expect(TelegramBot).to receive(:send_message).with(chat['id'], welcome_sms)

      dispatch_command(:start)
    end
  end

  describe '#associate!' do
    let!(:place) { create(:place) }
    let!(:user) { create(:user, phone: '011222333', place: place) }

    context 'wrong account' do
      let(:invalid_info_sms) { I18n.t("telegram_bot.invalid_info_message", username: chat["first_name"]) }

      it 'responses with invalid info message' do
        expect(TelegramBot).to receive(:send_message).with(chat['id'], invalid_info_sms)

        dispatch_command(:associate, '0112223', place.code)
      end
    end

    context 'valid account' do
      let(:configuration_sms) { I18n.t("telegram_bot.congratulation_message", username: chat["first_name"], place: place.display_name) }

      it 'responses with configuration message' do
        expect(TelegramBot).to receive(:send_message).with(chat['id'], configuration_sms)

        dispatch_command(:associate, '011222333', place.code)
      end

      it 'updates user with telegram_chat_id, telegram_chat_name' do
        dispatch_command(:associate, '011222333', place.code)

        expect(user.reload.telegram_chat_id).to eq(chat['id'])
      end
    end
  end
end
