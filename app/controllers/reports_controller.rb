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
    file = ReportCsv.start(params)
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

    values = Calendar.year_week_from_string(params[:week])

    if report.reviewed_as!(values[:year], values[:week])
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
      redirect_to reports_path, notice: 'Report has been deleted successfully'
    else
      redirect_to reports_path, alert: 'Failed to delete report'
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
