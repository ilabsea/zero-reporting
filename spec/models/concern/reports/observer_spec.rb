require 'rails_helper'

RSpec.describe Reports::Observer, type: :model do
  describe '#notify_completed_and_alert' do
    context "didn't notify if there is no message template is configured" do
      let!(:report) { create(:report, verboice_project_id: 1, status: Report::VERBOICE_CALL_STATUS_COMPLETED) }
      let!(:message_template) { Setting::MessageTemplateSetting.new(report_confirmation: 'On {{week_year}} with diseases: {{reported_cases}}') }

      it {
        expect(report).to receive(:notify_report_confirmation).never
        expect(report).to receive(:alert_checking).never

        report.notify_report_confirmation_and_alert
      }
    end

    context 'notify report confirmation when template is enabled' do
      let!(:report) { create(:report, verboice_project_id: 1, status: Report::VERBOICE_CALL_STATUS_COMPLETED) }
      let!(:message_template) { Setting::MessageTemplateSetting.new(enabled: true, report_confirmation: 'On {{week_year}} with diseases: {{reported_cases}}') }

      before(:each) do
        Setting.message_template = message_template
      end

      it {
        expect(report).to receive(:notify_report_confirmation).once
        expect(report).to receive(:alert_checking).never

        report.notify_report_confirmation_and_alert
      }
    end

    context 'Checking alert for every complete reports' do
      let!(:report) { create(:report, verboice_project_id: 1, status: Report::VERBOICE_CALL_STATUS_COMPLETED) }
      let!(:week) { Calendar.week(report.called_at.to_date) }

      before(:each) do
        allow(AlertSetting).to receive(:has_alert?).with(report.verboice_project_id).and_return(true)
      end

      it {
        expect(report).to receive(:notify_report_confirmation).never
        expect(report).to receive(:alert_checking).once

        report.notify_report_confirmation_and_alert
      }
    end
  end

  describe '#notify_report_confirmation' do
    let!(:report) { create(:report, verboice_project_id: 1) }
    let!(:message_template) { Setting::MessageTemplateSetting.new(enabled: true, report_confirmation: 'On {{week_year}} with diseases: {{reported_cases}}') }
    let(:alert) { :alert }
    let(:sms_alert_adapter) { Adapter::SmsAlertAdapter.new(alert) }

    describe 'on weekly case report' do
      context 'process alert sms when template is set and enabled' do
        before(:each) do
          Setting.message_template = message_template

          allow(Alerts::ReportConfirmationAlert).to receive(:new).with(instance_of(Setting::MessageTemplateSetting), report).and_return(alert)
        end

        it {
          expect(AdapterType).to receive(:for).with(alert).and_return(sms_alert_adapter)
          expect(sms_alert_adapter).to receive(:process)

          report.notify_report_confirmation
        }
      end
    end
  end

  describe '#alert_checking' do
    let!(:report) { create(:report, verboice_project_id: 1, status: Report::VERBOICE_CALL_STATUS_COMPLETED) }
    let!(:week) { Calendar.week(report.called_at.to_date) }

    context "didn't receive notify alert when having no alert variable" do
      before(:each) do
        allow(report).to receive(:having_alerted_variable?).and_return(false)
      end

      it {
        expect(report).to receive(:notify_alert).never

        report.alert_checking
      }
    end

    context "notify alert when having alert variable" do
      before(:each) do
        allow(report).to receive(:having_alerted_variable?).and_return(true)
      end

      it {
        expect(report).to receive(:notify_alert).once

        report.alert_checking
      }
    end
  end
end
