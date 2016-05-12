class WeeksController < ApplicationController
  def index
    @year = params[:year].present? ? Calendar::Year.new(params[:year].to_i) : Calendar::Year.new(Time.now.year)
    @weeks = @year.available_weeks.map { |w| { id: w.week_number, display: w.display(Calendar::Week::DISPLAY_ADVANCED_MODE) } }
    render json: @weeks, root: false
  end
end
