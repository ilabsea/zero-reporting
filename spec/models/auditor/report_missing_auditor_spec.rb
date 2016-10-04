require 'rails_helper'

RSpec.describe Auditor::ReportMissingAuditor, type: :model do
  let(:today) { Date.new(2016, 9, 14) }

  before(:each) do
    allow(Date).to receive(:today).and_return(today)
    allow(Calendar).to receive(:beginning_date_of_week).with(today).and_return(today)

    allow(Place).to receive(:missing_report_since).with(Date.new(2016, 8, 31)).and_return([])
  end

  describe 'audit' do
    context 'health center reporter' do
      let(:report_setting) { Setting::ReportSetting.new({ enables: ['sms'], x_week: 2, recipient_types: ['HC'] }) }
      let(:report_missing_auditor) { Auditor::ReportMissingAuditor.new(report_setting) }

      let(:auditor) { Auditor::Places::ReporterAuditor.new([], report_setting) }

      before(:each) do
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
        allow(Parser::PlaceAuditorParser).to receive(:parse).with('OD', [], report_setting).and_return(auditor)
      end

      it 'process reporter auditor' do
        expect(auditor).to receive(:audit).once

        report_missing_auditor.audit
      end
    end
  end
end
