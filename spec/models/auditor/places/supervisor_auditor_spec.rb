require 'rails_helper'

RSpec.describe Auditor::Places::SupervisorAuditor, type: :model do
  let(:od) { create(:od) }
  let!(:hc) { create(:hc, parent: od) }
  let(:places) { HC.all }

  let(:report_setting) { Setting::ReportSetting.new({ enabled: 1, x_week: 2, recipient_types: ['OD'] }) }

  let(:alert) { Alerts::Place::SupervisorAlert.new od, report_setting, places }
  let(:alert_context) { Contexts::SmsAlertContext.new alert }

  describe 'audit' do
    let(:auditor) { Auditor::Places::SupervisorAuditor.new(places, report_setting) }

    context 'process context alert' do
      before(:each) do
        allow(Place).to receive(:find).with("#{od.id}").and_return(od)
        allow(places).to receive(:where).with(ancestry: "#{od.ancestry}/#{od.id}").and_return(places)

        allow(Alerts::Place::SupervisorAlert).to receive(:new).with(od, report_setting, places).and_return(alert)
        allow(Contexts::SmsAlertContext).to receive(:new).with(alert).and_return(alert_context)
      end

      it {
        expect(alert_context).to receive(:process).once

        auditor.audit
      }
    end
  end
end
