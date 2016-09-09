require 'rails_helper'

RSpec.describe Alerts::VoiceAlert, type: :model do
  context '#enabled?' do
    context 'false when there is no voice enabled or week is undefined' do
      let(:report_setting) { Setting::ReportSetting.new({ enables: [], x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alerts::VoiceAlert.new nil, report_setting }

      it { expect(alert.enabled?).to eq(false) }
    end

    context 'true when there is no voice enabled and week is defined' do
      let(:report_setting) { Setting::ReportSetting.new({ enables: ['voice'], x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alerts::VoiceAlert.new nil, report_setting }

      it { expect(alert.enabled?).to eq(true) }
    end
  end

  context '#recipients' do
    let(:hc) { create(:hc) }
    let!(:user) { create(:user, phone: '1000', place: hc) }

    context 'list all user phone numbers those are belongs to place' do
      let(:report_setting) { Setting::ReportSetting.new({ enables: ['voice'], x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alerts::VoiceAlert.new hc, report_setting }

      it { expect(alert.has_recipients?).to eq(true) }
      it { expect(alert.recipients).to eq(['1000']) }
    end
  end

  context '#variables' do
    let(:report_setting) {
      Setting::ReportSetting.new({
        enables: ['voice'],
        x_week: 2,
        recipient_types: ['HC']
      })
    }

    before(:each) do
      report_setting.templates = { 'voice' => { channel_id: 1, call_flow_id: 1, call_time: '08:00' } }
      @alert = Alerts::VoiceAlert.new nil, report_setting
    end
    
    it { expect(@alert.variables).to eq({ channel_id: 1, call_flow_id: 1, not_before: "#{Date.today.strftime('%Y-%m-%d')} 08:00:00" }) }
  end
end
