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
    Report.create_from_call_log_with_status(params['CallSid'], Report::VERBOICE_CALL_STATUS_IN_PROGRESS)

    render json: {}
  end

  def notify_reporting_ended
    # run as async to remove delay time to deliver next step
    CallStatusJob.perform_later(params['CallSid'], Report::VERBOICE_CALL_STATUS_COMPLETED)

    render json: {}
  end

  def send_sms
    setting = ExternalSmsSetting.find_by(verboice_project_id: Setting[:project])

    alert = Alerts::ExternalServiceAlert.new(setting, params[:address], params[:CallSid])
    adapter = Adapter::SmsAlertAdapter.new(alert)
    adapter.process

    render json: {}
  end

  def detect_blacklist_number
    result = Setting.blacklist_numbers.include?(params[:address]) ? 1 : 0

    render json: { result: result.to_s }
  end

  def random_number
    begin
      number = params[:numbers].gsub(/\s+/, '').split(separator_delimeter).sample
      result = number ? number : ''
    rescue
      result = ''
    end
    
    render json: { result: result }
  end

  private

  def separator_delimeter
    ','
  end

end
