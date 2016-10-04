require 'rails_helper'

RSpec.describe Alerts::ExternalServiceAlert, type: :model do

  let(:setting) { create(:external_sms_setting, is_enable: true, message_template: '{{caller_phone}} has left voice message on call log {{call_log_id}}', recipients: ['85512345678', '8551012345678']) }
  let(:alert) { Alerts::ExternalServiceAlert.new(setting, '8551012345678', '1111') }

  context '#enabled?' do
    context 'false when it is not enabled or there is no any recipients defined' do
      let(:setting) { create(:external_sms_setting, is_enable: true, recipients: []) }
      let(:alert) { Alerts::ExternalServiceAlert.new(setting, '8551012345678', '1111') }

      it { expect(alert.enabled?).to eq(false) }
    end

    context 'true when enabled is equals 1 and week is defined' do
      it { expect(alert.enabled?).to eq(true) }
    end
  end

  describe '#recipients' do
    it { expect(alert.recipients).to include '85512345678' }
  end

  describe '#variables' do
    it { expect(alert.variables).to eq({caller_phone: '8551012345678', call_log_id: '1111'}) }
  end
end
