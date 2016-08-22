require 'rails_helper'

RSpec.describe Contexts::AlertContext, type: :model do
  include ActiveJob::TestHelper

  describe '#process' do
    context 'external service alert' do
      let(:setting) { create(:external_sms_setting, is_enable: true, message_template: '{{caller_phone}} has left voice message on call log {{call_log_id}}', recipients: ['85512345678', '8551012345678']) }
      let(:alert) { Alert::ExternalServiceAlert.new(setting, '1000', '1') }

      let(:context) { Contexts::AlertContext.new(alert) }

      it 'enqueue an alert job to queue' do
        context.process

        expect(enqueued_jobs.size).to eq(1)

        expect(enqueued_jobs.first[:job]).to eq(SmsQueueJob)
        expect(enqueued_jobs.first[:args].first).to eq({:receivers=>['85512345678', '8551012345678'], :body=>'1000 has left voice message on call log 1', :type=>nil})
      end
    end

    context 'report case alert' do
      let(:hc) { create(:hc) }
      let(:user) { create(:user, phone: '1000', place: hc) }
      let(:report) { create(:report, user: user) }
      let(:week) { Calendar::Year.new(2016).week(1) }
      let!(:setting) { create(:alert_setting, is_enable_sms_alert: true, message_template: 'This is the alert on {{week_year}} for {{reported_cases}}', verboice_project_id: 24, recipient_type: ['OD', 'HC']) }
      let(:alert) { Alert::ReportCaseAlert.new(setting, report, week) }

      let(:context) { Contexts::AlertContext.new(alert) }

      it 'enqueue an alert job to queue' do
        context.process

        expect(enqueued_jobs.size).to eq(1)

        expect(enqueued_jobs.first[:job]).to eq(SmsQueueJob)
        expect(enqueued_jobs.first[:args].first).to eq({:receivers=>['1000'], :body=>'This is the alert on w1-2016 for ', :type=>nil})
      end
    end

    context 'broadcast alert' do
      let(:user_1) { build(:user, phone: '1000') }
      let(:user_2) { build(:user, phone: '2000') }
      let(:alert) { Alert::BroadcastAlert.new([user_1, user_2], 'Testing message') }

      let(:context) { Contexts::AlertContext.new(alert) }

      it 'enqueue an alert job to queue' do
        context.process

        expect(enqueued_jobs.size).to eq(1)

        expect(enqueued_jobs.first[:job]).to eq(SmsQueueJob)
        expect(enqueued_jobs.first[:args].first).to eq({:receivers=>['1000', '2000'], :body=>'Testing message', :type=>nil})
      end
    end
  end
end
