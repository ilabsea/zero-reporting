require 'rails_helper'

RSpec.describe Alert::Place::SupervisorAlert, type: :model do
  let(:place) { create(:od) }
  let!(:hc) { create(:hc, name: 'HC_1', parent: place) }

  context '#enabled?' do
    context 'false when it has no recipient type as OD or PHD or child_places is empty' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::Place::SupervisorAlert.new nil, report_setting, [] }

      it { expect(alert.enabled?).to eq(false) }
    end

    context 'true when it has recipient type as OD or PHD' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['OD'] }) }
      let(:alert) { Alert::Place::SupervisorAlert.new nil, report_setting, HC.all }

      it { expect(alert.enabled?).to eq(true) }
    end
  end

  context '#variables' do
    context 'list all user phone numbers those are belongs to place' do
      let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['HC'] }) }
      let(:alert) { Alert::Place::SupervisorAlert.new hc, report_setting, HC.all }

      it { expect(alert.variables).to eq({ x_week: 2, place_name: 'HC_1' }) }
    end
  end
end
