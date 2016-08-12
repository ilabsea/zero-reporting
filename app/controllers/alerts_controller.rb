class AlertsController < ApplicationController
  authorize_resource
  def index
    @alert = Alert.find_or_initialize_by(verboice_project_id: Setting[:project])
  end

  def create
    @alert = Alert.new(filter_params)
    @alert.verboice_project_id = Setting[:project]
    if(@alert.save)
      redirect_to  settings_path, notice: 'Alert has been created successfully'
    else
      flash.now[:alert] = 'Failed to save alert'
      render :index
    end
  end

  def update
    @alert = Alert.find(params[:id])
    if @alert.update_attributes(filter_params)
      redirect_to settings_path, notice: 'Alert has been updated successfully'
    else
      render :index
    end
  end

  def log
    @logs = SmsLog.order("created_at desc").page(params[:page])
  end

  private
  def filter_params
    params.require(:alert).permit(:is_enable_sms_alert, :is_enable_email_alert, :message_template, recipient_type: [])
  end
end
