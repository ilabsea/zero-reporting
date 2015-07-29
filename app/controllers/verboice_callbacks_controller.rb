class VerboiceCallbacksController < ApplicationController
  skip_before_action :authenticate_user!

  http_basic_authenticate_with name: ENV['VERBOICE_NOTIFY_STATUS_USER'] , password: ENV['VERBOICE_NOTIFY_STATUS_PWD']

  def index
    if params['CallStatus'] == "completed" || params['CallStatus'] == "failed"
      Report.create_from_call_log_id(params['CallSid'])
    end
    render json: params
  end

end