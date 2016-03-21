# == Schema Information
#
# Table name: reports
#
#  id                   :integer          not null, primary key
#  phone                :string(255)
#  user_id              :integer
#  audio_key            :string(255)
#  called_at            :datetime
#  call_log_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  phone_without_prefix :string(255)
#  phd_id               :integer
#  od_id                :integer
#  status               :string(255)
#  duration             :float(24)
#  started_at           :datetime
#  call_flow_id         :integer
#  recorded_audios      :text(65535)
#  has_audio            :boolean          default(FALSE)
#  delete_status        :boolean          default(FALSE)
#  call_log_answers     :text(65535)
#  verboice_project_id  :integer
#  reviewed             :boolean          default(FALSE)
#  year                 :integer
#  week                 :integer
#  reviewed_at          :datetime
#  is_reached_threshold :boolean          default(FALSE)
#
# Indexes
#
#  index_reports_on_user_id        (user_id)
#  index_reports_on_year_and_week  (year,week)
#

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe ".create_from_verboice_attrs" do
    let(:verboice_attrs) do
      { "id"=>1503,
        "prefix_called_number"=>nil,
        "address"=>"17772415076",
        "duration"=>35,
        "direction"=>"incoming",
        "started_at"=>"2015-09-09T08:02:01Z",
        "call_flow_id"=>52,
        "state"=>"completed",
        "fail_reason"=>nil,
        "not_before"=>nil,
        "finished_at"=>"2015-09-09T08:02:36Z",
        "called_at"=>"2015-09-09T08:02:01Z",

        "account"=>{ "id"=>12, "email"=>"channa.info@gmail.com"},
        "project"=>{ "id"=>24, "name"=>"Health"},
        "channel"=>{"id"=>62, "name"=>"Simple - 17772071271" },

        "call_log_recorded_audios"=>[
              {"call_log_id"=>1503, "key"=>"1437448115867", "project_variable_id"=>73, "project_variable_name"=>"feed_back"},
              {"call_log_id"=>1503, "key"=>"1437450427859", "project_variable_id"=>93, "project_variable_name"=>"about"}],

        "call_log_answers"=>[
              {"id"=>689, "value"=>"2", "project_variable_id"=>91, "project_variable_name"=>"age"},
              {"id"=>690, "value"=>"3", "project_variable_id"=>77, "project_variable_name"=>"grade"},
              {"id"=>691, "value"=>"1", "project_variable_id"=>92, "project_variable_name"=>"score"},
              {"id"=>692, "value"=>"5", "project_variable_id"=>75, "project_variable_name"=>"is_hc_worker"}]}.with_indifferent_access

    end

    before(:each) do
      @variable1 = create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24 )
      @variable2 = create(:variable, name: 'grade', verboice_id: 77, verboice_name: 'grade', verboice_project_id: 24 )
      @variable3 = create(:variable, name: 'hc_worker', verboice_id: 75, verboice_name: 'is_hc_worker', verboice_project_id: 24 )
      @variable4 = create(:variable, name: 'feed_back', verboice_id: 73, verboice_name: 'feed_back', verboice_project_id: 24 )
      @variable5 = create(:variable, name: 'about', verboice_id: 93, verboice_name: 'about', verboice_project_id: 24 )
    end

    it 'create report' do
      report = Report.create_from_verboice_attrs(verboice_attrs)
      expect(report).to be_kind_of(Report)
      expect(report.duration).to eq(35)
      expect(report.verboice_project_id).to eq(24)
    end

    it 'create 3 report variable values' do
      report = Report.create_from_verboice_attrs(verboice_attrs)
      report_variable_values = report.report_variable_values

      expect(report_variable_values.length).to eq(3)

      expect(report_variable_values[0].value).to eq('2')
      expect(report_variable_values[0].report_id).to eq(report.id)
      expect(report_variable_values[0].variable.id).to eq(@variable1.id)

      expect(report_variable_values[1].value).to eq('3')
      expect(report_variable_values[1].report_id).to eq(report.id)
      expect(report_variable_values[1].variable.id).to eq(@variable2.id)

      expect(report_variable_values[2].value).to eq('5')
      expect(report_variable_values[2].report_id).to eq(report.id)
      expect(report_variable_values[2].variable.id).to eq(@variable3.id)
    end

    it 'create 2 report variable audios' do
      report = Report.create_from_verboice_attrs(verboice_attrs)
      report_variable_audios = report.report_variable_audios

      expect(report_variable_audios.length).to eq 2

      expect(report_variable_audios[0].value).to eq('1437448115867')
      expect(report_variable_audios[0].report_id).to eq(report.id)
      expect(report_variable_audios[0].variable.id).to eq(@variable4.id)

      expect(report_variable_audios[1].value).to eq('1437450427859')
      expect(report_variable_audios[1].report_id).to eq(report.id)
      expect(report_variable_audios[1].variable.id).to eq(@variable5.id)
    end

  end

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
    let(:place){create(:place)}
    let(:user){create(:user, place_id: place.id)}
    let(:report){create(:report, user_id: user.id)}
    it "return the place of reported user" do
      expect(report.place).to eq place
    end
  end

end
