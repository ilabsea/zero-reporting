class ExternalSmsSettingsController < ApplicationController
  authorize_resource

  def index
    @external_sms_setting = ExternalSmsSetting.find_or_initialize_by(verboice_project_id: Setting[:project])
  end

  def create
    @external_sms_setting = ExternalSmsSetting.new(filter_params)
    @external_sms_setting.verboice_project_id = Setting[:project]
    if(@external_sms_setting.save)
      redirect_to  external_sms_settings_path, notice: 'External SMS Setting has been created successfully'
    else
      flash.now[:alert] = 'Failed to save external sms setting'
      render :index
    end
  end

  def update
    @external_sms_setting = ExternalSmsSetting.find(params[:id])
    if @external_sms_setting.update_attributes(filter_params)
      redirect_to external_sms_settings_path, notice: 'External SMS Setting has been updated successfully'
    else
      render :index
    end
  end

  private
  def filter_params
    params.require(:external_sms_setting).permit(:is_enable, :message_template, recipients: [])
  end
end
