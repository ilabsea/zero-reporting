class ReportsController < ApplicationController

  authorize_resource

  def required_admin_role!

  end

  def index

    @reports = UserContext.new(current_user)
                     .reports
                     .includes(:report_variables, :user, :phd, :od)
                     .effective
                     .filter(params)
                     .includes(:phd, :od)
                     .order('id DESC')
                     .page(params[:page])
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
end