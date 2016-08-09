# encoding: UTF-8
require 'csv'

class ReportCsv
  def initialize user_context
    @user_context = user_context
  end

  def start options
    file = "#{Rails.root}/tmp/report-#{Date.current.strftime("%Y-%m-%d")}.csv"
    variables = Variable.applied(Setting[:project])

    CSV.open(file,"wb") do |csv|
      header = ['Date', 'PHD', 'OD', 'Phone', 'Username', 'Duration'] + variables.map(&:name) + ["Reviewed and assigned"] + ["CamEwarn submitted at"]

      csv << header
      reports = @user_context.reports.effective
                       .filter(options)
                       .includes(:phd, :od, :user)
                       .order('id DESC')

      reports.find_each(batch_size: 100) do |report|
        row = [ report.called_at.strftime(Report::DEFAULT_DISPLAY_DATE_FORMAT), report.phd.try(:name), report.od.try(:name), report.phone,
                report.user.try(:name), report.duration ]


        variables.each do |variable|
          report_variable = report.report_variables.select{|report_variable| report_variable.variable_id == variable.id}.first
          row << show_report_variable(report_variable)
        end
        row << (report.reviewed ? Calendar::Year.new(report.year).week(report.week).display : nil)
        row << (report.dhis2_submitted ? report.dhis2_submitted_at.strftime(Report::DEFAULT_DISPLAY_DATE_FORMAT) : nil)
        csv << row
      end
    end
    file
  end

  def show_report_variable(report_variable)
    return '' unless report_variable
    if report_variable.type == "ReportVariableAudio"
      Rails.application.routes.url_helpers.play_audio_report_variable_url(report_variable.token, host: ENV['HOST'])
    else
      report_variable.value
    end
  end

end
