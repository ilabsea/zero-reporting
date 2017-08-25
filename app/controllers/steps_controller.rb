class StepsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :required_admin_role!
  skip_before_action :verify_authenticity_token

  def manifest
    render file: File.join(Rails.root, 'config', 'step_manifest.xml')
  end

  def validate_hc_worker
    # 1 for voice reporting
    # 2 for keypad reporting, keep keypad as 2 to be consistent with previous release version
    result = User.reportable?(params[:address]) ? 2 : 0
    render json: { result: result.to_s }
  end

  def notify_reporting_started
    report = Report.create_from_call_log_with_status(params['CallSid'], Report::VERBOICE_CALL_STATUS_IN_PROGRESS)

    content = { result: report.in_progress? ? '1' : '0' }
    render json: content
  end

  def notify_reporting_ended
    report = Report.create_from_call_log_with_status(params['CallSid'], Report::VERBOICE_CALL_STATUS_COMPLETED)

    content = { result: report.success? ? '1' : '0' }
    render json: content
  end

  def send_sms
    setting = ExternalSmsSetting.find_by(verboice_project_id: Setting[:project])

    alert = Alerts::ExternalServiceAlert.new(setting, params[:address], params[:CallSid])
    adapter = Adapter::SmsAlertAdapter.new(alert)
    adapter.process

    render json: {}
  end

end
