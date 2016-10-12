class StepsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :required_admin_role!
  skip_before_action :verify_authenticity_token

  def manifest
    render file: File.join(Rails.root, 'config', 'step_manifest.xml')
  end

  def validate_hc_worker
    result = User.hc_worker?(params[:address]) ? 1 : 0
    if result == 1
      phone_without_prefix = Tel.new(params[:address]).without_prefix
      user = User.find_by(phone_without_prefix: phone_without_prefix)
      if user.od.code == '810'
        result = 1
      else
        result = 2
      end
    end
    content = "{\"result\": \"#{result}\" }"
    render text: content
  end

  def notify_reporting_started
    
    report = Report.create_from_call_log_with_status(params['CallSid'], Report::VERBOICE_CALL_STATUS_IN_PROGRESS)
    
    content = "{\"result\": \"#{report.in_progress? ? 1 : 0}\" }"
    render text: content
  end

  def notify_reporting_ended
    report = Report.create_from_call_log_with_status(params['CallSid'], Report::VERBOICE_CALL_STATUS_COMPLETED)

    content = "{\"result\": \"#{report.success? ? 1 : 0}\" }"
    render text: content
  end

  def send_sms
    setting = ExternalSmsSetting.find_by(verboice_project_id: Setting[:project])
    
    alert = Alerts::ExternalServiceAlert.new(setting, params[:address], params[:CallSid])
    adapter = Adapter::SmsAlertAdapter.new(alert)
    adapter.process

    render json: {}
  end

end
