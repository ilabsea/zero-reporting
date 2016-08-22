module Alert
  class ReportCaseAlert
    def initialize(setting, report, week)
      @setting = setting
      @report = report
      @week = week
    end

    def enabled?
      @setting.is_enable_sms_alert || !@report.alerted_variables.empty?
    end

    def message_template
      @setting.message_template
    end
    
    def recipients
      @recipients ||= recipient_users.map { |user| user.phone if user.phone.present? }.compact
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      SmsType.alert
    end

    def variables
      alerted_variables = @report.alerted_variables.map { |rv| {name: rv.name, value: rv.value, exceed_value: rv.exceed_value} }

      reported_cases = alerted_variables.map { |alerted_variable| MessageTemplate.instance.set_source!(ENV['REPORTED_CASE_ALERT_TEMPLATE']).interpolate(alerted_variable) }

      {
        week_year: @week.display(Calendar::Week::DISPLAY_NORMAL_MODE, "ww-yyyy"),
        reported_cases: reported_cases.join(" , "),
        place_name: @report.place.name
      }
    end

    private
    
    def recipient_users
      users = []
      
      place = @report.user.place
      @setting.recipient_type.each do |recipient|
        users = users + User.by_place(place.try(&recipient.to_sym.downcase).id) if recipient.present? && place.try(&recipient.to_sym.downcase)
      end

      users
    end
  end
end
