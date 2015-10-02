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

  def import

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

  def download_location_template
    respond_to do |format|
      format.json  { render :json => result }
      format.csv {
        content = "code,parent_code,name"
        render :text => content
      }
    end
  end

  def upload_location
    csv_string = File.read(params[:place].path, :encoding => 'utf-8')
    @hierarchy = Place.decode_hierarchy_csv(csv_string)
    @hierarchy_errors = Place.generate_error_description_list(@hierarchy)
    render :json => {:error => @hierarchy_errors, :data => @hierarchy}, :root => false
  end

  private

  def places_with_ref_path place_id
    places_path(place_id: place_id)
  end

  def filter_params
    params.require(:place).permit(:name, :code, :parent_id)
  end

end