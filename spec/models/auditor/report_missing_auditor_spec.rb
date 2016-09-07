require 'rails_helper'

RSpec.describe Auditor::ReportMissingAuditor, type: :model do
  describe 'audit' do
    context 'health center reporter' do
      let(:report_setting) { Setting::ReportSetting.new({ enables: ['sms'], x_week: 2, recipient_types: ['HC'] }) }
      let(:report_missing_auditor) { Auditor::ReportMissingAuditor.new(report_setting) }

      let(:auditor) { Auditor::Places::ReporterAuditor.new([], report_setting) }

      before(:each) do
        allow(Place).to receive(:missing_report_in).with(2.week).and_return([])
        allow(Parser::PlaceAuditorParser).to receive(:parse).with('HC', [], report_setting).and_return(auditor)
      end

      it 'process reporter auditor' do
        expect(auditor).to receive(:audit).once

        report_missing_auditor.audit
      end
    end

    context 'supervisor OD and PHD' do
      let(:report_setting) { Setting::ReportSetting.new({ enables: ['sms'], x_week: 2, recipient_types: ['OD'] }) }
      let(:report_missing_auditor) { Auditor::ReportMissingAuditor.new(report_setting) }

      let(:auditor) { Auditor::Places::SupervisorAuditor.new([], report_setting) }

      before(:each) do
        allow(Place).to receive(:missing_report_in).with(2.week).and_return([])
        allow(Parser::PlaceAuditorParser).to receive(:parse).with('OD', [], report_setting).and_return(auditor)
      end

      it 'process reporter auditor' do
        expect(auditor).to receive(:audit).once

        report_missing_auditor.audit
      end
    end
  end
end
