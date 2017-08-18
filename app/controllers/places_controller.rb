class PlacesController < ApplicationController

  skip_authorize_resource only: [:index]
  before_action :csv_settings, only: [:download_user]

  def index
    @places = Place.all
    @users = User.by_place(params[:place_id]).page(params[:page])
  end

  def new
    parent = params[:parent_id].present? ? Place.find(params[:parent_id]) : Place
    begin
      @place = parent.new_child
    rescue RuntimeError => ex
      redirect_to places_path, alert: ex.message
    end
  end

  def create
    @place = Place.new(protected_params)
    if @place.save
      redirect_to places_with_ref_path(@place.id), notice: 'Place has been created'
    else
      flash.now[:alert] = 'Failed to create place'
      render :new
    end
  end

  def edit
    @place = Place.find(params[:id])
    @available_parents = @place.parent_siblings
    @moving_state = params[:state] === Place::MODE_MOVING
  end

  def import

  end

  def download
    @filename = "Places_(#{Time.now.to_s.gsub(' ', '_')}).csv"
  end

  def download_users
    @filename = "Users_location_(#{Time.now.to_s.gsub(' ', '_')}).csv"
  end

  def update
    @place = Place.find(params[:id])
    if @place.update_attributes(protected_params)
      redirect_to places_with_ref_path(@place.id), notice: 'Place has been updated'
    else
      flash.now[:alert] = 'Failed to update place'
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

  def move
    @place = Place.find(params[:id])
    parent = Place.find(protected_params[:parent_id])
    if @place.move_to parent
      redirect_to places_with_ref_path(@place.id), notice: "Place has been moved to #{parent.name}"
    else
      flash.now[:alert] = 'Failed to move place'
      render :edit
    end
  end

  def ods_list
    render json: UserContext.for(current_user).ods_list(params[:phd_id]), root: false
  end

  private

  def places_with_ref_path place_id
    places_path(place_id: place_id)
  end

  def protected_params
    params.require(:place).permit(:name, :code, :dhis2_organisation_unit_uuid, :parent_id, :kind_of, :auditable)
  end

  # def csv_settings
  #   @output_encoding = 'UTF-8'
  #   @csv_options = { :force_quotes => true, :col_sep => ',' }
  #   @streaming = true
  # end

end
