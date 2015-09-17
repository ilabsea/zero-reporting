class PlacesController < ApplicationController
  def index
    @places = Place.all
    @users = User.by_place(params[:place_id]).page(params[:page])
  end

  def new
    @place = Place.new(parent_id: params[:parent_id])
  end

  def create
    @place = Place.new(filter_params)
    if @place.save
      redirect_to places_with_ref_path(@place.id), notice: 'Place has been created'
    else
      flash.now[:alert] = "Failed to create place"
      render :new
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    if @place.update_attributes(filter_params)
      redirect_to places_with_ref_path(@place.id), notice: 'Place has been updated'
    else
      flash.now[:alert] = "Failed to update place"
      render :edit
    end
  end

  def destroy
    @place = Place.find(params[:id])
    place_id = @place.parent ? @place.parent.id : ''

    begin
      @place.destroy
      redirect_to places_with_ref_path(place_id), notice: 'Place has removed'
    rescue ActiveRecord::StatementInvalid => error
      redirect_to places_with_ref_path(@place.id), alert: 'Failed to remove place. Make sure there are no users associate to this place'
    end

  end

  def ods_list
    render json: UserContext.new(current_user).ods_list(params[:phd_id])
  end

  private

  def places_with_ref_path place_id
    places_path(place_id: place_id)
  end

  def filter_params
    params.require(:place).permit(:name, :code, :parent_id)
  end

end