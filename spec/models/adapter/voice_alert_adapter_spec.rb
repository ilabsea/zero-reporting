require 'rails_helper'

RSpec.describe Adapter::VoiceAlertAdapter, type: :model do
  include ActiveJob::TestHelper

  describe '#process' do
    context 'alert to verboice' do
      let(:hc) { create(:hc) }
      let!(:user) { create(:user, phone: '1000', place: hc) }

      let(:report_setting) { Setting::ReportSetting.new({ enables: ['voice'], x_week: 2, recipient_types: ['HC'] }) }

      before(:each) do
        date = Date.new(2016, 9, 10)
        allow(Date).to receive(:today).and_return(date)

        report_setting.templates = { 'voice' => { channel_id: 1, call_flow_id: 1, call_time: '08:00' } }
        alert = Alerts::VoiceAlert.new hc, report_setting
        @adapter = Adapter::VoiceAlertAdapter.new(alert)
      end

      it 'enqueue an verboice alert job to queue' do
        @adapter.process

        expect(enqueued_jobs.size).to eq(1)

        expect(enqueued_jobs.first[:job]).to eq(VerboiceQueueJob)
        expect(enqueued_jobs.first[:args].first).to eq({ receivers: ['1000'], call_flow_id: 1, channel_id: 1, type: nil, not_before: '2016-09-10 08:00:00' })
      end
    end
  end
end
