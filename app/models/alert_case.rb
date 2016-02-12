class AlertCase
  def initialize(alert, report, week_year)
    @alert = alert
    @report = report
    @week_year = week_year
  end

  def run
    SmsAlertJob.set(wait: 1.minute).perform_later(message_options) if @alert.is_enable_sms_alert
  end

  def message_options
    message_options = []
    message_body = translate_message
    recipients.each do |recipient|
      sms = recipient.phone
      suggested_channel = Channel.suggested(Tel.new(sms))
      options = { from: "ZeroReporting",
                  to: "sms://#{sms}",
                  body: message_body,
                  suggested_channel: suggested_channel.name
                }
      message_options << options
    end
    message_options
  end

  def recipients
    place = @report.user.place
    recipients = []
    @alert.recipient_type.each do |recipient|
      if recipient == "PHD"
        recipients << User.by_place(place.phd.id)
      end

      if recipient == "OD"
        recipients << User.by_place(place.od.id)
      end

      if recipient == "HC"
        recipients << User.by_place(place.hc.id)
      end
    end
    recipients
  end

  def translate_message
    return "" unless @alert.message_template
    @report_variable_cases = @report.report_variables.where(is_reached_threshold: true)
    if !@report_variable_cases.empty?
      variable_cases = Variable.where(id: @report_variables_cases.pluck(:variable_id))
      translate_options = {
        week_year: @week_year,
        reported_cases: variable_cases.map(&:name).join(", ")
      }
      MessageTemplate.instance.set_source(@alert.message_template).translate(translate_options)
    end
    return ""
  end
end
