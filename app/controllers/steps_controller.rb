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
      elsif user.od.code == '801'
        result = 2
      end
    end
    content = "{\"result\": \"#{result}\" }"
    render text: content
  end

  def send_sms
    ExternalSms.new(params[:address], params[:CallSid]).run
    render json: {}
  end

end
