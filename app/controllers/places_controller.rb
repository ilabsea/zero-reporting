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
    # @available_parents = @place.phd.children.where.not(id: @place.parent_id)
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

  def download_template
    respond_to do |format|
      format.json  { render :json => result }
      format.csv { send_file 'public/sample/location_template.csv', type: 'text/csv' }
    end
  end

  def upload_location
    csv_string = File.read(params[:place].path, :encoding => 'utf-8')
    @hierarchy = Place.decode_hierarchy_csv(csv_string)
    @hierarchy_errors = Place.generate_error_description_list(@hierarchy)
    render :json => {:error => @hierarchy_errors, :data => @hierarchy}, :root => false
  end

  def confirm_upload_location
    csv_string = File.read(params[:place].path, :encoding => 'utf-8')
    csv = CSV.parse(csv_string)
    num_rows = 0
    csv.each do |col|
      unless col[1].present?
        parent = nil
      else
        parent = Place.generate_ancestry(col[1].strip)
      end
      Place.create!(:name => col[2].strip, :code => col[0].strip, :kind_of => col[3].strip, :ancestry => parent)
      num_rows = num_rows + 1
    end

    render :json => {:data => csv_string, :row_imported => num_rows}, :root => false
  end

  private

  def places_with_ref_path place_id
    places_path(place_id: place_id)
  end

  def protected_params
    params.require(:place).permit(:name, :code, :dhis2_organisation_unit_uuid, :parent_id, :kind_of, :auditable)
  end

  def csv_settings
    @output_encoding = 'UTF-8'
    @csv_options = { :force_quotes => true, :col_sep => ',' }
    @streaming = true
  end

end
