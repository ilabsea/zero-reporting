class AlertSettingsController < ApplicationController
  authorize_resource

  def index
    @alert_setting = AlertSetting.find_or_initialize_by(verboice_project_id: Setting[:project])
  end

  def create
    @alert_setting = AlertSetting.new(filter_params)
    @alert_setting.verboice_project_id = Setting[:project]
    if(@alert_setting.save)
      redirect_to  settings_path, notice: 'Alert has been created successfully'
    else
      flash.now[:alert] = 'Failed to save alert'
      render :index
    end
  end

  def update
    @alert_setting = AlertSetting.find(params[:id])
    if @alert_setting.update_attributes(filter_params)
      redirect_to settings_path, notice: 'Alert has been updated successfully'
    else
      render :index
    end
  end

  private
  def filter_params
    params.require(:alert_setting).permit(:is_enable_sms_alert, :is_enable_email_alert, :message_template, recipient_type: [])
  end
end
