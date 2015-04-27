class PhdsController < ApplicationController
  def index
    @phds = Phd.page(params[:page]).per(20)
  end

  def new
    @phd = Phd.new
  end

  def create
    @phd = Phd.new(filter_params)
    if(@phd.save)
      redirect_to  phds_path, notice: 'PHD has been created successfully'
    else
      flash.now[:alert] = 'Failed to save PHD'
      render :new
    end
  end

  def edit
    @phd = Phd.find(params[:id])
  end

  def update
    @phd = Phd.find(params[:id])
    if @phd.update_attributes(filter_params)
      redirect_to phds_path, notice: 'PHD has been updated successfully'
    else
      flash.now[:alert] = 'Failed to update PHD'
      render :edit
    end
  end

  def destroy
    @phd = Phd.find(params[:id])
    if @phd.destroy
      redirect_to phds_path, notice: 'PHD has been deleted'
    else
      redirect_to phds_path, alert: 'Failed to remove PHD'
    end
  end

  def od_list
    list = Od.order("name DESC").where(phd_id: params[:id]).pluck(:name, :id)
    render json: list
  end


  private

  def filter_params
    params.require(:phd).permit(:name, :code)
  end
end