require 'rails_helper'

RSpec.describe Adapter::TelegramAlertAdapter, type: :model do
  include ActiveJob::TestHelper

  describe '#process' do
    let(:display_message) { MessageTemplate.instance.set_source!(alert.message_template).interpolate(alert.variables) }
    let(:adapter) { Adapter::TelegramAlertAdapter.new(alert) }
    let(:queue_option) { enqueued_jobs.first[:args].first.delete_if { |k, v| k === '_aj_symbol_keys' }}

    context 'report confirm alert' do
      let(:report) { create(:report, user: user) }
      let(:alert)  { report.confirm_alert }
      let(:message_template) { Setting::MessageTemplateSetting.new(enabled: true, report_confirmation: 'On {{week_year}} with diseases: {{reported_cases}}') }


      before {
        Setting[:message_template] = message_template
        adapter.process
      }

      context 'has telegram account' do
        let(:user)   { create(:user, telegram_chat_id: '111') }

        it { expect(enqueued_jobs.size).to eq(1) }
        it { expect(enqueued_jobs.first[:job]).to eq(TelegramQueueJob) }
        it { expect(queue_option).to eq({ "user_id" => user.id, "message" => display_message}) }
      end

      context 'no telegram account' do
        let(:user)   { create(:user, telegram_chat_id: nil) }

        it { expect(enqueued_jobs.size).to eq(0) }
      end
    end

    context 'report case alert' do
      let!(:setting) { create(:alert_setting, is_enable_sms_alert: true, message_template: 'This is the alert on {{week_year}} for {{reported_cases}}', verboice_project_id: 24, recipient_type: ['OD', 'HC']) }
      let!(:hc)      { create(:hc) }
      let(:report)   { create(:report, user: user, phone: '2000', verboice_project_id: setting.verboice_project_id) }
      let(:alert)    { report.case_alert }

      before {
        adapter.process
      }

      context 'has telegram account' do
        let(:user)   { create(:user, phone: '1000', place: hc, telegram_chat_id: '111') }

        it { expect(enqueued_jobs.size).to eq(1) }
        it { expect(enqueued_jobs.first[:job]).to eq(TelegramQueueJob) }
        it { expect(queue_option).to eq({ "user_id" => user.id, "message" => display_message}) }
      end

      context 'no telegram account' do
        let(:user) { create(:user, telegram_chat_id: nil) }

        it { expect(enqueued_jobs.size).to eq(0) }
      end
    end

    context 'broadcast alert' do
      let(:user_1)  { create(:user, phone: '1000', telegram_chat_id: '111') }
      let(:user_2)  { create(:user, phone: '2000') }
      let(:alert)   { Alerts::BroadcastAlert.new([user_1, user_2], 'Testing message') }

      context 'notify only the user having telegram_chat_id' do
        before {
          adapter.process
        }

        it { expect(enqueued_jobs.size).to eq(1) }
        it { expect(enqueued_jobs.first[:job]).to eq(TelegramQueueJob) }
        it { expect(queue_option).to eq({ "user_id" => user_1.id, "message" => 'Testing message'}) }
      end
    end
  end
end
