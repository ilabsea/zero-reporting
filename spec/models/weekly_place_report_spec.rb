require 'rails_helper'

RSpec.describe WeeklyPlaceReport, type: :model do
  let(:week) {Calendar.week(Date.new(2016, 02, 10))}
  let!(:hc){create(:hc, code: "hc_1")}
  let!(:hc_user) {create(:user, name: "hc_user", username: "hc_user", phone: "85512345678", place_id: hc.id)}
  let(:verboice_attrs_1) do
    { "id"=>1501,
      "prefix_called_number"=>nil,
      "address"=>"85512345678",
      "duration"=>35,
      "direction"=>"incoming",
      "started_at"=>"2016-02-03T08:02:01Z",
      "call_flow_id"=>52,
      "state"=>"completed",
      "fail_reason"=>nil,
      "not_before"=>nil,
      "finished_at"=>"2016-02-03T08:02:36Z",
      "called_at"=>"2016-02-03T08:02:01Z",

      "account"=>{ "id"=>12, "email"=>"channa.info@gmail.com"},
      "project"=>{ "id"=>24, "name"=>"Health"},
      "channel"=>{"id"=>62, "name"=>"Simple - 17772071271" },

      "call_log_recorded_audios"=>[],

      "call_log_answers"=>[
            {"id"=>689, "value"=>"2", "project_variable_id"=>91, "project_variable_name"=>"age"},
            {"id"=>690, "value"=>"3", "project_variable_id"=>77, "project_variable_name"=>"grade"},
            {"id"=>691, "value"=>"1", "project_variable_id"=>92, "project_variable_name"=>"score"},
            {"id"=>692, "value"=>"5", "project_variable_id"=>75, "project_variable_name"=>"is_hc_worker"}]}.with_indifferent_access

  end

  let(:verboice_attrs_2) do
    { "id"=>1503,
      "prefix_called_number"=>nil,
      "address"=>"85512345678",
      "duration"=>35,
      "direction"=>"incoming",
      "started_at"=>"2016-02-10T08:02:01Z",
      "call_flow_id"=>52,
      "state"=>"completed",
      "fail_reason"=>nil,
      "not_before"=>nil,
      "finished_at"=>"2016-02-10T08:02:36Z",
      "called_at"=>"2016-02-10T08:02:01Z",

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

  let(:verboice_attrs_3) do
    { "id"=>1502,
      "prefix_called_number"=>nil,
      "address"=>"85512345678",
      "duration"=>35,
      "direction"=>"incoming",
      "started_at"=>"2016-02-15T08:02:01Z",
      "call_flow_id"=>52,
      "state"=>"completed",
      "fail_reason"=>nil,
      "not_before"=>nil,
      "finished_at"=>"2016-02-15T08:02:36Z",
      "called_at"=>"2016-02-15T08:02:01Z",

      "account"=>{ "id"=>12, "email"=>"channa.info@gmail.com"},
      "project"=>{ "id"=>24, "name"=>"Health"},
      "channel"=>{"id"=>62, "name"=>"Simple - 17772071271" },

      "call_log_recorded_audios"=>[],

      "call_log_answers"=>[
            {"id"=>689, "value"=>"3", "project_variable_id"=>91, "project_variable_name"=>"age"},
            {"id"=>690, "value"=>"1", "project_variable_id"=>77, "project_variable_name"=>"grade"},
            {"id"=>691, "value"=>"1", "project_variable_id"=>92, "project_variable_name"=>"score"}]}.with_indifferent_access

  end

  before(:each) do
    @variable1 = create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24)
    @variable2 = create(:variable, name: 'grade', verboice_id: 77, verboice_name: 'grade', verboice_project_id: 24)
    @variable3 = create(:variable, name: 'hc_worker', verboice_id: 75, verboice_name: 'is_hc_worker', verboice_project_id: 24)
    @variable4 = create(:variable, name: 'feed_back', verboice_id: 73, verboice_name: 'feed_back', verboice_project_id: 24)
    @variable5 = create(:variable, name: 'about', verboice_id: 93, verboice_name: 'about', verboice_project_id: 24)
    @report1= Parser::ReportParser.parse(verboice_attrs_1)
    @report1.reviewed_as!(2016, week.previous.week_number)
    @report2 = Parser::ReportParser.parse(verboice_attrs_2)
    @report2.reviewed_as!(2016, week.week_number)
    @report3 = Parser::ReportParser.parse(verboice_attrs_3)
    @report3.reviewed_as!(2016, week.week_number)
    @weekly_place_report = WeeklyPlaceReport.new(week, hc)
  end

  describe "#reports" do
    it "return reports" do
      expect(@weekly_place_report.reports).to include(@report2)
      expect(@weekly_place_report.reports).to include(@report3)
      expect(@weekly_place_report.reports).not_to include(@report1)
    end
  end

  describe "#total_value_by_variable" do
    it "return total_value_by_variable" do
      expect(@weekly_place_report.total_value_by_variable(@variable1.id)).to eq(5)
      expect(@weekly_place_report.total_value_by_variable(@variable2.id)).to eq(4)
      expect(@weekly_place_report.total_value_by_variable(@variable3.id)).to eq(5)
    end

  end
end
