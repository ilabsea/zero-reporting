module Reports::Observer
  extend ActiveSupport::Concern

  included do
    after_save :notify_report_confirmation_and_alert, if: :finished_with_status_changed?

    def notify_report_confirmation_and_alert
      # report confirmation
      notify_report_confirmation if Setting.message_template && Setting.message_template.enabled?

      # Checking alert
      alert_checking if AlertSetting.has_alert?(self.verboice_project_id)
    end

    def notify_report_confirmation
      # TODO Refactoring to remove alert_setting dependency
      return unless self.has_report_variabled? && Setting.message_template.report_confirmation.present?

      [:sms, :telegram].each do |type|
        AdapterType.for(confirm_alert, type).process
      end
    end

    def confirm_alert
      @confirm_alert ||= Alerts::ReportConfirmationAlert.new(Setting.message_template, self)
    end

    def alert_checking
      # TODO Refactoring
      self.report_variable_values.each do |report_variable|
        report_variable.check_alert_for(self.camewarn_week, self.place) if report_variable.alert_defined?
      end

      self.notify_alert if self.having_alerted_variable?
    end
  end
end
