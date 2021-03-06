require 'rails_helper'

RSpec.describe Alerts::ReportCaseAlert, type: :model do

  let!(:week) { Calendar.week(Date.new(2016,02,10)) }
  let!(:od){ create(:od) }
  let!(:hc){ create(:hc, name: 'Testing HC', parent: od) }
  let!(:od_user) { create(:user, name: 'od_user', username: 'od_user', phone: '85510345678', place_id: od.id) }
  let!(:hc_user) { create(:user, name: 'hc_user', username: 'hc_user', phone: '85512345678', place_id: hc.id) }
  let!(:alert_setting) { create(:alert_setting, is_enable_sms_alert: true, message_template: 'This is the alert on {{week_year}} for {{reported_cases}}.', verboice_project_id: 24, recipient_type: ['OD', 'HC']) }
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

      'call_log_recorded_audios'=>[
            {'call_log_id'=>1503, 'key'=>'1437448115867', 'project_variable_id'=>73, 'project_variable_name'=>'feed_back'},
            {'call_log_id'=>1503, 'key'=>'1437450427859', 'project_variable_id'=>93, 'project_variable_name'=>'about'}],

      'call_log_answers'=>[
            {'id'=>689, 'value'=>'2', 'project_variable_id'=>91, 'project_variable_name'=>'age'},
            {'id'=>690, 'value'=>'3', 'project_variable_id'=>77, 'project_variable_name'=>'grade'},
            {'id'=>691, 'value'=>'1', 'project_variable_id'=>92, 'project_variable_name'=>'score'},
            {'id'=>692, 'value'=>'5', 'project_variable_id'=>75, 'project_variable_name'=>'is_hc_worker'}]
    }.with_indifferent_access
  end

  before(:each) do
    @variable1 = create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, alert_method: 'formula')
    @variable2 = create(:variable, name: 'grade', verboice_id: 77, verboice_name: 'grade', verboice_project_id: 24, alert_method: 'formula')
    @variable3 = create(:variable, name: 'hc_worker', verboice_id: 75, verboice_name: 'is_hc_worker', verboice_project_id: 24, alert_method: 'formula')
    @variable4 = create(:variable, name: 'feed_back', verboice_id: 73, verboice_name: 'feed_back', verboice_project_id: 24, alert_method: 'formula')
    @variable5 = create(:variable, name: 'about', verboice_id: 93, verboice_name: 'about', verboice_project_id: 24, alert_method: 'formula')

    @report = Parser::ReportParser.parse(verboice_attrs)
    @report.reviewed_as!(2016, week.week_number)
    @report.update_status!(Report::VERBOICE_CALL_STATUS_COMPLETED)

    allow(@report).to receive(:camewarn_week).and_return(week)

    @report_alert = Alerts::ReportCaseAlert.new(alert_setting, @report)
  end

  context '#enabled?' do
    context 'false when sms is not enabled or there is no any alert variables defined' do
      let(:alert_setting) { create(:alert_setting, is_enable_sms_alert: false) }

      before(:each) do
        @report_alert = Alerts::ReportCaseAlert.new(alert_setting, @report)

        allow(@report).to receive(:alerted_variables).and_return([])
      end

      it { expect(@report_alert.enabled?).to eq(false) }
    end

    context 'true when enabled is equals 1 and week is defined' do
      before(:each) do
        allow(@report).to receive(:alerted_variables).and_return([{}])
      end

      it { expect(@report_alert.enabled?).to eq(true) }
    end
  end

  describe '#recipients' do
    it 'return the recipients according to alert_recipient_type' do
      expect(@report_alert.recipients).to include('85510345678')
      expect(@report_alert.recipients).to include('85510345678')
    end
  end

  describe '#variables' do
    it { expect(Calendar::Year.new(2016).week(7).display(Calendar::Week::DISPLAY_ADVANCED_MODE)).to eq('w7 10.02.2016 - 16.02.2016') }
    it { expect(@report_alert.variables).to eq({ week_year: 'w7-2016', reported_cases: 'age: 2(2.0) , grade: 3(3.0) , hc_worker: 5(5.0)', place_name: 'Testing HC' }) }
  end

end
