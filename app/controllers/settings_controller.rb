class SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings   = Setting.unscoped
    @parameters = verboice_parameters
    @variables  = Variable.where(verboice_project_id: Setting[:project])

  end

  def update_settings
    [:project, :project_variable].each do |key|
      Setting[key] = params[key]
    end

    store_variables
    redirect_to settings_path, notice: 'Setting has been saved'
  end

  def store_variables
    Variable.save_from_params(params)
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

  def project_variables
    @project_variables = get_project_variables(params[:project])
    @variables  = Variable.where(verboice_project_id: params[:project])

    render layout:false
  end

  def get_project_variables(project_id)
    project_id.present? ? Service::Verboice.connect(Setting).project_variables(project_id) : []
  end

  def verboice_parameters
    result = {projects: [], project_variables: [] }

    begin
      result[:projects]   = Service::Verboice.connect(Setting).projects
      result[:project_variables]  = get_project_variables(Setting[:project])
    rescue JSON::ParserError
      flash.now.alert = " Failed to fetch some data from verboice"
    end

    result
  end
end
