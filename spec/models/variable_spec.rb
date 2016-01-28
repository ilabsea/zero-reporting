require 'rails_helper'

RSpec.describe Variable, type: :model do

  context "initialized" do
    let(:variable) { described_class.new(name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, background_color: '#203de3', text_color: '#d4b91e') }
    it "create varibale" do
      expect(variable.text_color).to eq('#d4b91e')
      expect(variable.background_color).to eq('#203de3')
    end
  end

  describe "#total_report_value" do
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

      report = Report.create_from_verboice_attrs(verboice_attrs)
      @report_ids = [report.id]
    end
    context 'when variable has been reported' do
      it "return the sum value" do
        expect(@variable1.total_report_value(@report_ids)).to eq(2)
        expect(@variable2.total_report_value(@report_ids)).to eq(3)
      end
    end

    context "when variable has not been reported" do
      it "return nil" do
        expect(@variable4.total_report_value(@report_ids)).to eq(nil)
      end
    end
  end
end
