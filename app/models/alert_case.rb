class AlertCase
  def initialize(alert, report, week)
    @alert = alert
    @report = report
    @week = week
    @alerted_variables = @report.alerted_variables
  end

  def run
    return if @alert.is_enable_sms_alert == false || @alerted_variables.empty?
    messages = message_options
    if !messages.empty?
      SmsJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(messages)
    end
  end

  def message_options
    message_options = []
    message_body = translate_message
    recipients.each do |recipient|
      suggested_channel = AlertCase.channel_suggested(recipient.phone)
      if suggested_channel
        phone = Tel.new(recipient.phone).with_country_code
        message_options << { from: ENV['APP_NAME'],
                             to: "sms://#{phone}",
                             body: message_body,
                             suggested_channel: suggested_channel.name
                           }
      end
    end
    message_options
  end

  def self.channel_suggested(recipient_phone)
    Channel.suggested(Tel.new(recipient_phone))
  end

  def recipients
    place = @report.user.place
    recipients = []
    @alert.recipient_type.each do |recipient|
      if recipient == Place::PLACE_TYPE_PHD
        recipients = recipients + User.by_place(place.phd.id) if !place.phd.nil?
      end

      if recipient == Place::PLACE_TYPE_OD
        recipients = recipients + User.by_place(place.od.id) if !place.od.nil?
      end

      if recipient == Place::PLACE_TYPE_HC
        recipients = recipients + User.by_place(place.hc.id) if !place.hc.nil?
      end
    end
    recipients
  end

  def translate_message
    return "" unless @alert.message_template
    translate_options = {
      week_year: @week.display(Calendar::Week::DISPLAY_NORMAL_MODE, "ww-yyyy"),
      reported_cases: translate_reported_cases.join(" , "),
      place_name: @report.place.name
    }
    return MessageTemplate.instance.set_source(@alert.message_template).translate(translate_options)
  end

  def translate_reported_cases
    reported_case = @alerted_variables.map{|rv| {name: rv.name, value: rv.value, exceed_value: rv.exceed_value}}
    MessageTemplate.instance.set_source(ENV['REPORTED_CASE_ALERT_TEMPLATE']).translate_reported_cases(reported_case)
  end
end
