class SmsLogsController < ApplicationController
  # GET /sms_logs
  def index
    @logs = SmsLog.order("created_at desc").page(params[:page])
  end
end
