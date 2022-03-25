# == Schema Information
#
# Table name: reports
#
#  id                         :integer          not null, primary key
#  phone                      :string(255)
#  user_id                    :integer
#  audio_key                  :string(255)
#  listened                   :boolean
#  called_at                  :datetime
#  call_log_id                :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  phone_without_prefix       :string(255)
#  phd_id                     :integer
#  od_id                      :integer
#  status                     :string(255)
#  duration                   :float(24)
#  started_at                 :datetime
#  call_flow_id               :integer
#  recorded_audios            :text(65535)
#  has_audio                  :boolean          default(FALSE)
#  delete_status              :boolean          default(FALSE)
#  call_log_answers           :text(65535)
#  verboice_project_id        :integer
#  reviewed                   :boolean          default(FALSE)
#  year                       :integer
#  week                       :integer
#  reviewed_at                :datetime
#  is_reached_threshold       :boolean          default(FALSE)
#  dhis2_submitted            :boolean          default(FALSE)
#  dhis2_submitted_at         :datetime
#  dhis2_submitted_by         :integer
#  place_id                   :integer
#  verboice_sync_failed_count :integer          default(0)
#
# Indexes
#
#  index_call_failed_status                   (call_log_id,verboice_sync_failed_count,status)
#  index_reports_on_delete_status             (delete_status)
#  index_reports_on_od_id_and_delete_status   (od_id,delete_status)
#  index_reports_on_phd_id_and_delete_status  (phd_id,delete_status)
#  index_reports_on_place_id                  (place_id)
#  index_reports_on_user_id                   (user_id)
#  index_reports_on_weekly_reviewed           (place_id,year,week,reviewed,delete_status)
#  index_reports_on_year_and_week             (year,week)
#

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe "#camewarn_week" do
    context "when report is on sunday" do
      let(:report) {create(:report, called_at: "2016-03-20 11:39:45")}

      it "return the week previous" do
        week = Calendar.week(report.called_at.to_date)
        expect(report.camewarn_week.week_number).to eq week.previous.week_number
      end
    end

    context "when report is after wednesday" do
      let(:report) {create(:report, called_at: "2016-03-18 11:39:45")}

      it "return the week previous" do
        week = Calendar.week(report.called_at.to_date)
        expect(report.camewarn_week.week_number).to eq week.previous.week_number
      end
    end

    context "when report is not on sunday and before wednesday" do
      let(:report) {create(:report, called_at: "2016-03-21 11:39:45")}

      it "return the current report week" do
        week = Calendar.week(report.called_at.to_date)
        expect(report.camewarn_week.week_number).to eq week.week_number
      end
    end
  end

  describe "#place" do
    let(:place){create(:phd)}
    let(:user){create(:user, place_id: place.id)}
    let(:report){create(:report, user_id: user.id)}

    it "return the place of reported user" do
      expect(report.place).to eq place
    end
  end

  describe ".audit_missing" do
    let!(:report_setting) { Setting.report = Setting::ReportSetting.new({ days: ["0"], x_week: 2, recipient_types: ['HC'], enables: [] }) }

    before(:each) do
      today = double('today')

      allow(Date).to receive(:today).and_return(today)
      allow(today).to receive(:wday).and_return(0)
    end

    it 'should has enable Sunday' do
      report_setting.has_day?(Date.today.wday)
    end

    it 'should ReportMissingAuditor process audit' do
      expect_any_instance_of(Auditor::ReportMissingAuditor).to receive(:audit).once

      Report.audit_missing
    end
  end

  describe '#sync_call' do
    let(:report) { create(:report, status: Report::VERBOICE_CALL_STATUS_IN_PROGRESS, call_log_id: 9999) }

    context 'notify sync call failed when exception is occured' do
      let(:verboice_call_log) { { 'state' => 'completed' } }

      before(:each) do
        allow(Report).to receive(:new_or_initialize_from_call_log).with(verboice_call_log).and_return(report)
        allow(report).to receive(:notify_sync_call_completed).and_raise(StandardError.new("Error while updating reporting or sync state"))
      end

      it {
        expect(report).to receive(:notify_sync_call_failed).once

        Report.sync_call verboice_call_log
      }
    end

    context 'notify sync call completed when call is failed' do
      let(:verboice_call_log) { { 'state' => 'failed' } }

      before(:each) do
        allow(Report).to receive(:new_or_initialize_from_call_log).with(verboice_call_log).and_return(report)
      end

      it {
        expect(report).to receive(:notify_sync_call_completed).once

        Report.sync_call verboice_call_log
      }
    end

    context 'notify sync call completed when call is completed' do
      let(:verboice_call_log) { { 'state' => 'completed' } }

      before(:each) do
        allow(Report).to receive(:new_or_initialize_from_call_log).with(verboice_call_log).and_return(report)
      end

      it {
        expect(report).to receive(:notify_sync_call_completed).once

        Report.sync_call verboice_call_log
      }
    end
  end

  describe '#notify_sync_call_completed' do
    let(:report) { create(:report, status: Report::VERBOICE_CALL_STATUS_IN_PROGRESS, call_log_id: 9999) }

    it 'mark as completed when call is completed' do
      report.notify_sync_call_completed

      expect(report.reload.status).to eq(Report::VERBOICE_CALL_STATUS_COMPLETED)
    end

    it 'write state of call log id synchronized' do
      report.notify_sync_call_completed

      expect(VerboiceSyncState.last.last_call_log_id).to eq(report.call_log_id)
    end
  end

  describe '#notify_sync_call_failed' do
    context 'increment retries failed' do
      let(:report) { create(:report, status: Report::VERBOICE_CALL_STATUS_IN_PROGRESS, verboice_sync_failed_count: 0) }

      it {
        report.notify_sync_call_failed

        expect(report.reload.verboice_sync_failed_count).to eq(1)
      }
    end

    context 'mark as failed when retries reach maximum attempt' do
      let(:report) { create(:report, status: Report::VERBOICE_CALL_STATUS_IN_PROGRESS, verboice_sync_failed_count: 2) }

      it {
        report.notify_sync_call_failed

        expect(report.reload.status).to eq(Report::VERBOICE_CALL_STATUS_FAILED)
      }
    end
  end

  describe 'checking alert' do
    context 'ignore when call is in-progress' do
      let(:report) { build(:report, status: Report::VERBOICE_CALL_STATUS_IN_PROGRESS, verboice_sync_failed_count: 0) }

      it {
        expect(report).to receive(:alert_checking).exactly(0).times
        report.save
      }
    end

    context 'ignore when review on call finished' do
      let!(:report) { create(:report, status: Report::VERBOICE_CALL_STATUS_COMPLETED, verboice_sync_failed_count: 0) }

      it {
        expect(report).to receive(:alert_checking).exactly(0).times

        report.reviewed = true
        report.save
      }
    end

    context 'when call is finished' do
      let(:report) { build(:report, status: Report::VERBOICE_CALL_STATUS_COMPLETED, verboice_sync_failed_count: 0) }

      before(:each) do
        allow(AlertSetting).to receive(:has_alert?).with(report.verboice_project_id).and_return(true)
      end

      it {
        expect(report).to receive(:alert_checking).once
        report.save
      }
    end
  end

  describe '#notify_alert' do
    let!(:report) { create(:report, verboice_project_id: 1) }
    let!(:alert_setting) { create(:alert_setting, is_enable_sms_alert: true, message_template: 'This is the alert on {{week_year}} for {{reported_cases}}.', verboice_project_id: 1, recipient_type: ['OD', 'HC']) }
    let(:alert) { :alert }
    let(:sms_alert_adapter) { Adapter::SmsAlertAdapter.new(alert) }
    let(:telegram_alert_adapter) { Adapter::TelegramAlertAdapter.new(alert) }

    describe 'on weekly case report' do
      context 'process alert sms when sms option is enabled' do
        before(:each) do
          allow(AlertSetting).to receive(:get).with(1).and_return(alert_setting)
          allow(Alerts::ReportCaseAlert).to receive(:new).with(alert_setting, report).and_return(alert)
        end

        it {
          expect(AdapterType).to receive(:for).with(alert, :sms).ordered.and_return(sms_alert_adapter)
          expect(sms_alert_adapter).to receive(:process)

          expect(AdapterType).to receive(:for).with(alert, :telegram).ordered.and_return(telegram_alert_adapter)
          expect(telegram_alert_adapter).to receive(:process)

          report.notify_alert
        }
      end
    end
  end

  describe '#alerted_variables' do
    before(:each) do
      @variable1 = create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, is_alerted_by_threshold: true)
      @report = create(:report)
      @report_variable = create(:report_variable, report: @report, variable: @variable1, is_alerted: true)
    end

    it { expect(@report.alerted_variables.size).to eq 1 }

  end

end
