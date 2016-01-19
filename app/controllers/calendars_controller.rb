class CalendarsController < ApplicationController
  def index
    year = params[:year].present? ? params[:year] : Time.now.year
    @available_weeks = Calendar.available_weeks(year)

    render json: @available_weeks
  end

end
