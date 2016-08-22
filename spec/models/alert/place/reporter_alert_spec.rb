require 'rails_helper'

RSpec.describe Alert::Place::ReporterAlert, type: :model do
  context '#enabled?' do
    context 'false when it has no recipient type as HC' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['OD'] }) }
      let(:alert) { Alert::Place::ReporterAlert.new nil, report_setting }

      it { expect(alert.enabled?).to eq(false) }
    end

    context 'true when it has recipient type as HC' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::Place::ReporterAlert.new nil, report_setting }

      it { expect(alert.enabled?).to eq(true) }
    end
  end

  context '#variables' do
    let(:hc) { create(:hc, name: 'HC_1') }
    let!(:user) { build(:user, phone: '1000', place: hc) }
    let!(:report) { create(:report, called_at: '2016-08-19 00:00:00', user: user, place: hc) }

    context 'list all user phone numbers those are belongs to place' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::Place::ReporterAlert.new hc, report_setting }

      it { expect(report.called_at.wday).to eq 5 } # wday 0: sunday..6: saturday
      it { expect(alert.variables).to eq({ x_week: 2, place_name: 'HC_1', last_reported: 'Fri 19-08-16 00:00' }) }
    end
  end
end
