class SettingsController < ApplicationController
  authorize_resource

  def index
    # to get all items for render list
    Setting[:project] = params[:project] if params[:project]
    @settings   = Setting.unscoped
    @parameters = verboice_parameters
    @variables  = Variable.where(verboice_project_id: Setting[:project])
    @alert_setting = AlertSetting.find_or_initialize_by(verboice_project_id: Setting[:project])
    @report_setting = Setting.report || Setting::ReportSetting.new {}
    @message_template = Setting.message_template || Setting::MessageTemplateSetting.new {}
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
      redirect_to settings_path(tab: Setting::VERBOICE), notice: 'Successfully connected to verboice'
    else
      flash.now[:alert] = 'Could not connect to verboice'
      render :index
    end
  end

  # PUT /hub
  def hub
    # TODO refactoring to Setting[:hub] to store HubSetting Object
    Setting[:hub_url] = params[:url]
    Setting[:hub_email] = params[:email]
    Setting[:hub_password] = params[:password] if params[:password].present?
    Setting[:hub_task_name] = params[:task_name]

    redirect_to settings_path(tab: Setting::HUB), notice: 'Hub connection has been saved'
  end

  # PUT /settings/update_report
  def update_report
    if params[:report].present?
      report_setting = Setting::ReportSetting.new(params[:report])
      report_setting.templates = params[:report][:templates]
      Setting[:report] = report_setting
    end

    redirect_to settings_path(tab: Setting::REPORT), notice: 'Report setting has been saved'
  end

  # PUT /settings/update_message_template
  def update_message_template
    if params[:message_template].present?
      message_template = Setting::MessageTemplateSetting.new(params[:message_template])
      Setting[:message_template] = message_template
    end

    redirect_to settings_path(tab: Setting::TEMPLATE), notice: 'Report setting has been saved'
  end

  private

  def verboice_parameters
    parameters = { projects: [], project_variables: [] }

    begin
      parameters[:projects] = Service::Verboice.connect(Setting).projects
      parameters[:project_variables] = project_variables(Setting[:project])
      parameters[:project_call_flows] = project_call_flows(Setting[:project])
      parameters[:channels] = Service::Verboice.connect(Setting).channels
    rescue JSON::ParserError
      flash.now.alert = " Failed to fetch some data from verboice"
    end

    parameters
  end

  def project_variables(project_id)
    project_id.present? ? Service::Verboice.connect(Setting).project_variables(project_id) : []
  end

  def project_call_flows project_id
    project_id.present? ? Service::Verboice.connect(Setting).project_call_flows(project_id) : []
  end

end
