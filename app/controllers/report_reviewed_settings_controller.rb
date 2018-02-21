class ReportReviewedSettingsController < ApplicationController
  authorize_resource

  def index
    @report_setting = ReportReviewedSetting.find_or_initialize_by(verboice_project_id: Setting[:project])
  end

  def create
    @report_setting = ReportReviewedSetting.new(filter_params)
    @report_setting.verboice_project_id = Setting[:project]
    if(@report_setting.save)
      redirect_to  settings_path(tab: Setting::NOTIFY_REPORT_REVIEWED), notice: 'Report Setting has been created successfully'
    else
      redirect_to  settings_path(tab: Setting::NOTIFY_REPORT_REVIEWED), :flash => { :error => 'Failed to save report setting'}
    end
  end

  def update
    @report_setting = ReportReviewedSetting.find(params[:id])
    if @report_setting.update_attributes(filter_params)
      redirect_to settings_path(tab: Setting::NOTIFY_REPORT_REVIEWED), notice: 'Report Setting has been updated successfully'
    else
      redirect_to  settings_path(tab: Setting::NOTIFY_REPORT_REVIEWED), :flash => { :error => 'Failed to save report setting'}
    end
  end

  private
  def filter_params
    params.require(:report_reviewed_setting).permit(:endpoint, :username, :password)
  end
end
