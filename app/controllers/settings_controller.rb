class SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings = Setting.unscoped
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
end
