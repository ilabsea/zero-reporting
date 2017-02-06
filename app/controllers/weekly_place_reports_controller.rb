class WeeklyPlaceReportsController < ApplicationController
  authorize_resource

  before_action :validate_params, only: [:index]
  before_action :load_user_context, only: [:index]

  # GET /weekly_place_reports
  def index
    week = Calendar::Week.parse(params[:week])

    reports = @user_context.reports.reviewed_by_weekly_place(params[:place_id], week).includes(:place)
    render json: reports, root: false
  end

  private

  def validate_params
    head(422) if !params[:week].present? || !params[:place_id].present?
  end

  def load_user_context
    @user_context = UserContext.for(current_user)
  end
end
