class LogsController < ApplicationController
  before_action :filter, only: [:index]

  # GET /logs
  def index
    @logs = Log.by_kind(@kind)
    @logs = @logs.by_type(@type) if @type

    @logs = @logs.order("created_at desc").page(params[:page])
  end

  private

  def filter
    @kind = params[:kind].present? ? params[:kind] : :sms
    @type = LogType.find_by_id(params[:type]) if params[:type].present?
  end
end
