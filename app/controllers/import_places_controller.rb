class ImportPlacesController < ApplicationController

  def new

  end

  def create
    csv_string = File.read(params[:place].path, :encoding => 'utf-8')
    places = PlaceCSV.new(csv_string).import
    render json: places
  end

  def decode
    csv_string = File.read(params[:place].path, :encoding => 'utf-8')
    place_csv = PlaceCSV.new(csv_string)
    hierarchy = place_csv.decode
    hierarchy_errors = place_csv.generate_error_description_list
    render :json => {:error => hierarchy_errors, :data => hierarchy}, :root => false
  end


  def template
    respond_to do |format|
      format.json  { render :json => result }
      format.csv { send_file 'public/sample/location_template.csv', type: 'text/csv' }
    end
  end
end
