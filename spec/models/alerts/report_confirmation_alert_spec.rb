require 'rails_helper'

RSpec.describe Alerts::ReportConfirmationAlert, type: :model do

  let!(:week) { Calendar.week(Date.new(2016,02,10)) }
  let!(:od){ create(:od) }
  let!(:hc){ create(:hc, name: 'Testing HC', parent: od) }
  let!(:hc_user) { create(:user, name: 'hc_user', username: 'hc_user', phone: '85512345678', place_id: hc.id) }
  let!(:message_template_setting) { Setting::MessageTemplateSetting.new(report_confirmation: 'On {{week_year}} with template {{reported_cases}}') }

  let!(:variable1) { create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, alert_method: 'none') }
  let!(:variable2) { create(:variable, name: 'grade', verboice_id: 77, verboice_name: 'grade', verboice_project_id: 24, alert_method: 'none') }

  let(:verboice_attrs) do
    {
      'id'=>1503,
      'prefix_called_number'=>nil,
      'address'=>'85512345678',
      'duration'=>35,
      'direction'=>'incoming',
      'started_at'=>'2016-02-10T08:02:01Z',
      'call_flow_id'=>52,
      'state'=>'completed',
      'fail_reason'=>nil,
      'not_before'=>nil,
      'finished_at'=>'2016-02-10T08:02:36Z',
      'called_at'=>'2016-02-10T08:02:01Z',

      'account'=>{'id'=>12, 'email'=>'channa.info@gmail.com'},
      'project'=>{'id'=>24, 'name'=>'Health'},
      'channel'=>{'id'=>62, 'name'=>'Simple - 17772071271'},

      'call_log_recorded_audios'=>[],

      'call_log_answers'=>[
        {'id'=>689, 'value'=>'2', 'project_variable_id'=>91, 'project_variable_name'=>'age'},
        {'id'=>690, 'value'=>'3', 'project_variable_id'=>77, 'project_variable_name'=>'grade'}
      ]
    }.with_indifferent_access
  end

  before(:each) do
    @report = Parser::ReportParser.parse(verboice_attrs)
    @report.save!

    allow(@report).to receive(:camewarn_week).and_return(week)

    @report_alert = Alerts::ReportConfirmationAlert.new(message_template_setting, @report)
  end

  describe '#variables' do
    it { expect(Calendar::Year.new(2016).week(7).display(Calendar::Week::DISPLAY_ADVANCED_MODE)).to eq('w7 10.02.2016 - 16.02.2016') }
    it { expect(@report_alert.variables).to eq({ week_year: 'w7-2016', reported_cases: 'age(2), grade(3)' }) }
  end

end
