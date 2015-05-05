class PlacesController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @place = Place.new(parent_id: params[:parent_id])
  end

  def create
    @place = Place.new(filter_params)
    if @place.save
      redirect_to places_path(place_id: @place.id), notice: 'Place has been created'
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
      redirect_to places_path(place_id: @place.id), notice: 'Place has been updated'
    else
      flash.now[:alert] = "Failed to update place"
      render :edit
    end
  end

  def destroy
    @place = Place.find(params[:id])
    place_id = @place.parent ? @place.parent.id : ''
    if @place.destroy
      redirect_to places_path(place_id: place_id ), notice: 'Place has removed'
    else
      redirect_to places_path(place_id: place_id), alert: 'Failed to remove place'
    end
  end

  private
  def filter_params
    params.require(:place).permit(:name, :code, :parent_id)
  end

end