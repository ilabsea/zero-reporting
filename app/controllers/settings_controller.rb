class SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings = Setting.unscoped
    @parameters = verboice_parameters
  end

  def update_settings
    [:project, :channel, :call_flow].each do |key|
      Setting[key] = params[key]
    end
    redirect_to settings_path, notice: 'Setting has been saved'
  end

  def verboice
    response = Service::Verboice.auth(params[:email], params[:password])
    Setting[:verboice_email] = params[:email]
    Setting[:verboice_token] = nil

    if response && response["success"]
      Setting[:verboice_token] = response["auth_token"]
      redirect_to settings_path, notice: 'Successfully connected to verboice'
    else
      flash.now[:alert] = 'Could not connect to verboice'
      render :index
    end
  end

  def schedules
    render json: get_schedules(params[:project])
  end

  def get_schedules(project_id)
    Service::Verboice.connect(Setting).schedules(project_id)
  end

  def verboice_parameters
    result = { channels: [], projects: [], call_flows: [], schedules: [] }

    begin
      result[:channels]   = Service::Verboice.connect(Setting).channels
      result[:projects]   = Service::Verboice.connect(Setting).projects
      result[:call_flows] = Service::Verboice.connect(Setting).call_flows
      result[:schedules]  = get_schedules(Setting[:project]) unless Setting[:project].blank?
    rescue JSON::ParserError
      flash.now.alert = " Failed to fetch some data from verboice"
    end

    result
  end
end
