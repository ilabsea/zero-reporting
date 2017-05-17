module Alerts
  class ReportConfirmationAlert
    def initialize(setting, report)
      @setting = setting
      @report = report
    end

    def enabled?
      true
    end

    def message_template
      @setting.report_confirmation
    end

    def recipients
      @recipients ||= [@report.user.phone]
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      LogType.report_confirmation
    end

    def variables
      {
        week_year: @report.camewarn_week.display(Calendar::Week::DISPLAY_NORMAL_MODE, "ww-yyyy"),
        reported_cases: reported_cases
      }
    end

    private

    def reported_cases
      @report.report_variables.map { |rv| "#{rv.variable.try(:name)}(#{rv.value})" } .join(", ")
    end

  end
end
