# == Schema Information
#
# Table name: reports
#
#  id                         :integer          not null, primary key
#  phone                      :string(255)
#  user_id                    :integer
#  audio_key                  :string(255)
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
#  index_call_failed_status          (call_log_id,verboice_sync_failed_count,status)
#  index_reports_on_place_id         (place_id)
#  index_reports_on_user_id          (user_id)
#  index_reports_on_weekly_reviewed  (place_id,year,week,reviewed,delete_status)
#  index_reports_on_year_and_week    (year,week)
#

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe "#week_for_alert" do
    context "when report is on sunday" do
      let(:report) {create(:report, called_at: "2016-03-20 11:39:45")}
      
      it "return the week previous" do
        week = Calendar.week(report.called_at.to_date)
        expect(report.week_for_alert.week_number).to eq week.previous.week_number
      end
    end

    context "when report is after wednesday" do
      let(:report) {create(:report, called_at: "2016-03-18 11:39:45")}
      
      it "return the week previous" do
        week = Calendar.week(report.called_at.to_date)
        expect(report.week_for_alert.week_number).to eq week.previous.week_number
      end
    end

    context "when report is not on sunday and before wednesday" do
      let(:report) {create(:report, called_at: "2016-03-21 11:39:45")}
      
      it "return the current report week" do
        week = Calendar.week(report.called_at.to_date)
        expect(report.week_for_alert.week_number).to eq week.week_number
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

end
