require 'rails_helper'

RSpec.describe Contexts::VoiceAlertContext, type: :model do
  include ActiveJob::TestHelper

  describe '#process' do
    context 'alert to verboice' do
      let(:hc) { create(:hc) }
      let!(:user) { create(:user, phone: '1000', place: hc) }

      let(:report_setting) { Setting::ReportSetting.new({ enables: ['voice'], x_week: 2, recipient_types: ['HC'] }) }

      before(:each) do
        report_setting.templates = { 'voice' => { channel_id: 1, call_flow_id: 1 } }
        alert = Alerts::VoiceAlert.new hc, report_setting
        @context = Contexts::VoiceAlertContext.new(alert)
      end

      it 'enqueue an verboice alert job to queue' do
        @context.process

        expect(enqueued_jobs.size).to eq(1)

        expect(enqueued_jobs.first[:job]).to eq(VerboiceQueueJob)
        expect(enqueued_jobs.first[:args].first).to eq(['1000'])
        expect(enqueued_jobs.first[:args].last).to eq({ channel_id: 1, call_flow_id: 1 })
      end
    end
  end
end
