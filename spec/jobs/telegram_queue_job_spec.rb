# frozen_string_literal: true

require "rails_helper"

RSpec.describe TelegramQueueJob, type: :job do
  describe '#perform' do
    let(:user)    { create(:user, telegram_chat_id: '111') }
    let(:message) { "Testing message" }

    context 'has telegram account' do
      it 'push notification to the reporter with message' do
        expect(TelegramBot).to receive(:send_message).with(user.telegram_chat_id, message)

        TelegramQueueJob.new.perform({user_id: user.id, message: message})
      end
    end

    context 'no telegram account' do
      let(:user)   { create(:user, telegram_chat_id: nil) }

      it 'does not push notification to the reporter' do
        expect(TelegramBot).not_to receive(:send_message)

        TelegramQueueJob.new.perform({user_id: user.id, message: message})
      end
    end
  end
end
