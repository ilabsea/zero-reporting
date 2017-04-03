module Reports::AlertObservable
  extend ActiveSupport::Concern

  included do
    after_save :alert_checking, if: :finished_with_status_changed?

    def alert_checking
      return if !AlertSetting.has_alert?(self.verboice_project_id)

      # TODO Refactoring
      self.report_variable_values.each do |report_variable|
        report_variable.check_alert_for(self.alert_week, self.place)
      end

      self.notify_alert
    end
  end
end
