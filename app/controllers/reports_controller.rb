class ReportsController < ApplicationController
  def index
    @reports = Report.effective
                     .filter(params)
                     .includes(:phd, :od)
                     .order('id DESC')
                     .page(params[:page])

    @variables = Variable.applied(Setting[:project])
  end

  def destroy
    report = Report.find(params[:id])
    report.delete_status = true
    if report.save
      redirect_to reports_path, notice: 'Report has been deleted successfully'
    else
      redirect_to reports_path, alert: 'Failed to delete report'
    end
  end
end