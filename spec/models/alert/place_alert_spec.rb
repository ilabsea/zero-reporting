require 'rails_helper'

RSpec.describe Alert::PlaceAlert, type: :model do
  context '#enabled?' do
    context 'false when enabled is not equals 1 or week is undefined' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 0, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::PlaceAlert.new nil, report_setting }

      it { expect(alert.enabled?).to eq(false) }
    end

    context 'true when enabled is equals 1 and week is defined' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::PlaceAlert.new nil, report_setting }

      it { expect(alert.enabled?).to eq(true) }
    end
  end

  context '#recipients' do
    let(:hc) { create(:hc) }
    let!(:user) { create(:user, phone: '1000', place: hc) }

    context 'list all user phone numbers those are belongs to place' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::PlaceAlert.new hc, report_setting }

      it { expect(alert.has_recipients?).to eq(true) }
      it { expect(alert.recipients).to eq(['1000']) }
    end
  end
end
