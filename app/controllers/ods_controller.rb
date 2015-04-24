class OdsController < ApplicationController
  def index
    @ods = Od.page(params[:page]).per(20)
  end

  def new
    @od = Od.new
  end

  def create
    @od = Od.new(filter_params)
    if(@od.save)
      redirect_to  ods_path, notice: 'OD has been created successfully'
    else
      flash.now[:alert] = 'Failed to save OD'
      render :new
    end
  end

  def edit
    @od = Od.find(params[:id])
  end

  def update
    @od = Od.find(params[:id])
    if @od.update_attributes(filter_params)
      redirect_to ods_path, notice: 'OD has been updated successfully'
    else
      flash.now[:alert] = 'Failed to update OD'
      render :edit
    end
  end

  def destroy
    @od = Od.find(params[:id])
    if @od.destroy
      redirect_to ods_path, notice: 'OD has been deleted'
    else
      redirect_to ods_path, alert: 'Failed to remove phd'
    end
  end


  private

  def filter_params
    params.require(:od).permit(:name, :code, :phd_id)
  end
end