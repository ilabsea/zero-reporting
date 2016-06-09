module Api
  class PlacesController < ApiController

    skip_authorize_resource only: [:index]

    def index
      @places = Place.all
      @places = @places.where("name LIKE ?", "%#{params[:q]}%") if params[:q].present?
      @places = @places.where(kind_of: params[:level]) if params[:level].present?

      render json: @places, root: false
    end

  end
end
