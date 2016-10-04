require 'rails_helper'

RSpec.describe Auditor::Places::SupervisorAuditor, type: :model do
  let(:od) { create(:od) }
  let!(:hc) { create(:hc, parent: od) }
  let(:places) { HC.all }

  let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['OD'] }) }

  let(:alert) { Alerts::Place::SupervisorAlert.new od, report_setting, places }
  let(:adapter) { Adapter::SmsAlertAdapter.new alert }

  describe 'audit' do
    let(:auditor) { Auditor::Places::SupervisorAuditor.new(places, report_setting) }

    context 'process adapter alert' do
      before(:each) do
        allow(Place).to receive(:find).with("#{od.id}").and_return(od)
        allow(places).to receive(:where).with(ancestry: "#{od.ancestry}/#{od.id}").and_return(places)

        allow(Alerts::Place::SupervisorAlert).to receive(:new).with(od, report_setting, places).and_return(alert)
        allow(Adapter::SmsAlertAdapter).to receive(:new).with(alert).and_return(adapter)
      end

      it {
        expect(adapter).to receive(:process).once

        auditor.audit
      }
    end
  end
end
