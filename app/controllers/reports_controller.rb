class ReportsController < ApplicationController
  authorize_resource

  helper_method :sort_column, :sort_direction

  def required_admin_role!

  end

  def index
    reports = UserContext.new(current_user).reports.includes(:report_variables, :user, :phd, :od)
                     .effective
                     .filter(params)
                     .includes(:phd, :od)
    reports = sort_column ? reports.order(sort_column + " " + sort_direction) : reports.order('id DESC')
    @report_ids = reports.map(&:id)
    @reports_by_page = reports.page(params[:page])
    @variables = Variable.applied(Setting[:project])

    @events = Event.upcoming(1.week).order("from_date ASC").limit(Event::ANNOUNCEMENT_LISTING)
    @events = EventDecorator.decorate_collection(@events)
  end

  def query_piechart
    @reports = UserContext.new(current_user)
                     .reports
                     .includes(:report_variables, :user, :phd, :od)
                     .effective
                     .filter(params)
                     .includes(:phd, :od)
                     .order('id DESC')
    data_review = Report.to_piechart_reviewed(@reports)
    data_phd = Report.to_piechart_phd(@reports)
    render :json => {:review => data_review, :phd => data_phd}
  end

  def export_as_csv
    file = ReportCsv.new(UserContext.new(current_user)).start(params)
    send_file file, type: "text/csv"
  end

  def toggle_status
    report = Report.find(params[:id])
    authorize! :update, report

    if report.toggle_status
      head :ok
    else
      render nothing: true, status: 400
    end
  end

  def update_week
    report = Report.find(params[:id])
    authorize! :update, report

    week = Calendar::Week.parse(params[:week])

    if report.reviewed_as!(week.year.number, week.week_number)
      head :ok
    else
      render nothing: true, status: :not_found
    end
  end

  def destroy
    @report = Report.find(params[:id])
    authorize! :destroy, @report

    @report.delete_status = true
    if @report.save
      redirect_to request.referrer, notice: 'Report has been deleted successfully'
    else
      redirect_to request.referrer, alert: 'Failed to delete report'
    end
  end

  private

  def sort_column
    Report.column_names.include?(params[:sort]) ? params[:sort] : nil
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
