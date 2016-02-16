class AlertCase
  def initialize(alert, report, week_year)
    @alert = alert
    @report = report
    @week_year = week_year
    @report_variable_cases = @report.report_variables.where(is_reached_threshold: true)
  end

  def run
    messages = message_options
    SmsAlertJob.set(wait: 1.minute).perform_later(messages) if @alert.is_enable_sms_alert && !@report_variable_cases.empty?
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
        recipients = recipients + User.by_place(place.phd.id)
      end

      if recipient == "OD"
        recipients = recipients + User.by_place(place.od.id)
      end

      if recipient == "HC"
        recipients = recipients + User.by_place(place.hc.id)
      end
    end
    recipients
  end

  def translate_message
    return "" unless @alert.message_template
    variable_ids = @report_variable_cases.pluck(:variable_id)
    variable_cases = Variable.where(id: variable_ids)
    translate_options = {
      week_year: @week_year,
      reported_cases: variable_cases.map(&:name).join(", ")
    }
    return MessageTemplate.instance.set_source(@alert.message_template).translate(translate_options)
  end
end
