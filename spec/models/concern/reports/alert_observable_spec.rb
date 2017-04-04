require 'rails_helper'

RSpec.describe Reports::AlertObservable, type: :model do
  describe '#alert_checking' do
    context 'Checking alert for every complete reports' do
      let!(:report) { create(:report, verboice_project_id: 1, status: Report::VERBOICE_CALL_STATUS_COMPLETED) }
      let!(:week) { Calendar.week(report.called_at.to_date) }

      before(:each) do
        allow(AlertSetting).to receive(:has_alert?).with(report.verboice_project_id).and_return(true)
        allow(report).to receive(:having_alerted_variable?).and_return(true)
      end

      it {
        expect(report).to receive(:notify_alert).once

        report.alert_checking
      }
    end
  end
end
