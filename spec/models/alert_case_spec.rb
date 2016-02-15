require 'rails_helper'

RSpec.describe AlertCase, type: :model do
  include ActiveJob::TestHelper

  let(:week) {Calendar.week_number(DateTime.now().to_date)}
  let!(:place){create(:hc)}
  let!(:smart){create(:channel, name: "smart", setup_flow: Channel::SETUP_FLOW_GLOBAL)}
  let!(:camgsm){create(:channel, name: "camgsm", setup_flow: Channel::SETUP_FLOW_GLOBAL)}
  let!(:user) {create(:user, name: "tester", username: "tester", phone: "85512345678", place_id: place.id)}
  let!(:alert) {create(:alert, is_enable_sms_alert: true, message_template: "This is the alert on {{week_year}} for {{reported_cases}}.", verboice_project_id: 24, recipient_type: ["HC"])}
  let(:verboice_attrs) do
    { "id"=>1503,
      "prefix_called_number"=>nil,
      "address"=>"85512345678",
      "duration"=>35,
      "called_at"=>"2015-09-09T08:02:01Z",
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
    @report = Report.create_from_verboice_attrs(verboice_attrs)
    @alert_case = AlertCase.new(alert, @report, "w#{week}-#{DateTime.now.year}")
  end

  describe "#run" do
    it "create a job for send sms alert" do
      expect(enqueued_jobs.size).to eq(1)
    end
  end

  describe "#message_options" do
    it "return the message_options" do
      expect(@alert_case.message_options.size).to eq(1)
      expect(@alert_case.message_options[0][:body]).to eq "This is the alert on w#{week}-#{DateTime.now.year} for age, grade, hc_worker, feed_back, about."
      expect(@alert_case.message_options[0][:suggested_channel]).to eq Tel.new(user.phone).carrier
    end
  end

  describe "#recipients" do
    it "return the recipients according to alert_recipient_type" do
      expect(@alert_case.recipients).to include(user)
    end
  end

  describe "#translate_message" do
    it "return the translate_message" do
      expect(@alert_case.translate_message).to eq "This is the alert on w#{week}-#{DateTime.now.year} for age, grade, hc_worker, feed_back, about."
    end
  end

end
