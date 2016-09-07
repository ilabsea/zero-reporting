require 'rails_helper'

RSpec.describe Auditor::Places::ReporterAuditor, type: :model do
  let(:hc) { build(:hc) }
  let(:places) { [hc] }

  let(:report_setting) { Setting::ReportSetting.new({ enables: ['sms'], x_week: 2, recipient_types: ['HC'] }) }

  let(:alert) { Alerts::Place::ReporterAlert.new hc, report_setting }
  let(:alert_context) { Contexts::SmsAlertContext.new alert }

  describe 'audit' do
    let(:auditor) { Auditor::Places::ReporterAuditor.new(places, report_setting) }

    context 'process context alert' do
      before(:each) do
        allow(Alerts::Place::ReporterAlert).to receive(:new).with(hc, report_setting).and_return(alert)
        allow(Contexts::SmsAlertContext).to receive(:new).with(alert).and_return(alert_context)
      end

      it {
        expect(alert_context).to receive(:process).once

        auditor.audit
      }
    end
  end
end
