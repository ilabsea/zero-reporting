# == Schema Information
#
# Table name: variables
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)
#  verboice_id         :integer
#  verboice_name       :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  background_color    :string(255)
#  text_color          :string(255)
#

require 'rails_helper'

RSpec.describe Variable, type: :model do
  let(:week) {Calendar.week(Date.new(2016, 02, 10))}
  let(:verboice_attrs_1) do
    { "id"=>1501,
      "prefix_called_number"=>nil,
      "address"=>"85512345678",
      "duration"=>35,
      "direction"=>"incoming",
      "started_at"=>"2016-01-27T08:02:01Z",
      "call_flow_id"=>52,
      "state"=>"completed",
      "fail_reason"=>nil,
      "not_before"=>nil,
      "finished_at"=>"2016-01-27T08:02:36Z",
      "called_at"=>"2016-01-27T08:02:01Z",

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
    { "id"=>1502,
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
            {"id"=>689, "value"=>"3", "project_variable_id"=>91, "project_variable_name"=>"age"},
            {"id"=>690, "value"=>"1", "project_variable_id"=>77, "project_variable_name"=>"grade"},
            {"id"=>691, "value"=>"1", "project_variable_id"=>92, "project_variable_name"=>"score"},
            {"id"=>692, "value"=>"5", "project_variable_id"=>75, "project_variable_name"=>"is_hc_worker"}]}.with_indifferent_access

  end

  let(:verboice_attrs_3) do
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

  before(:each) do
    @variable1 = create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24 )
    @variable2 = create(:variable, name: 'grade', verboice_id: 77, verboice_name: 'grade', verboice_project_id: 24 )
    @variable3 = create(:variable, name: 'hc_worker', verboice_id: 75, verboice_name: 'is_hc_worker', verboice_project_id: 24 )
    @variable4 = create(:variable, name: 'feed_back', verboice_id: 73, verboice_name: 'feed_back', verboice_project_id: 24 )
    @variable5 = create(:variable, name: 'about', verboice_id: 93, verboice_name: 'about', verboice_project_id: 24 )
    @report1= Report.create_from_verboice_attrs(verboice_attrs_1)
    @report1.reviewed_as!(2016, week.previous.previous.week_number)
    @report2 = Report.create_from_verboice_attrs(verboice_attrs_2)
    @report2.reviewed_as!(2016, week.previous.week_number)
    @report3 = Report.create_from_verboice_attrs(verboice_attrs_3)
    @report3.reviewed_as!(2016, week.week_number)
    @report_ids = [@report3.id]
  end

  context "initialized" do
    let(:variable) { described_class.new(name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, background_color: '#203de3', text_color: '#d4b91e') }
    it "create varibale" do
      expect(variable.text_color).to eq('#d4b91e')
      expect(variable.background_color).to eq('#203de3')
    end
  end

  describe "#total_report_value" do
    context 'when variable has been reported' do
      it "return the sum value" do
        expect(@variable1.total_report_value([@report3.id])).to eq(2)
        expect(@variable1.total_report_value([@report3.id, @report2.id])).to eq(5)
        expect(@variable1.total_report_value([@report3.id, @report2.id, @report1.id])).to eq(7)
        expect(@variable2.total_report_value([@report3.id])).to eq(3)
      end
    end

    context "when variable has not been reported" do
      it "return 0" do
        expect(@variable4.total_report_value(@report_ids)).to eq(0)
      end
    end
  end

  describe "#threshold_by_week" do
    it "return threshold on week 3" do
      expect(@variable1.threshold_by_week(week.previous.previous)).to eq(0)
      expect(@variable2.threshold_by_week(week.previous.previous)).to eq(0)
      expect(@variable3.threshold_by_week(week.previous.previous)).to eq(0)
    end

    it "return threshold on week 4" do
      expect(@variable1.threshold_by_week(week.previous)).to eq(1)
      expect(@variable2.threshold_by_week(week.previous)).to eq(1.5)
      expect(@variable3.threshold_by_week(week.previous)).to eq(2.5)
    end

    it "return threshold on week 5" do
      expect(@variable1.threshold_by_week(week)).to eq(2.5)
      expect(@variable2.threshold_by_week(week)).to eq(2)
      expect(@variable3.threshold_by_week(week)).to eq(5)
    end
  end

end
