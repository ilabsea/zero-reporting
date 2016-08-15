class AlertCase
  def initialize(alert, report, week)
    @alert = alert
    @report = report
    @week = week
  end

  def run
    return if @alert.is_enable_sms_alert == false || @report.alerted_variables.empty?

    message_body = @alert.message_template ? MessageTemplate.instance.set_source!(@alert.message_template).interpolate(variables) : ""
    receivers = recipients.map { |user| user.phone if user.phone.present? }.compact

    sms = Sms::Message.new(receivers, message_body, SmsType.alert)

    SmsQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(sms.to_hash)
  end

  def recipients
    recipients = []

    place = @report.user.place
    @alert.recipient_type.each do |recipient|
      recipients = recipients + User.by_place(place.try(&recipient.to_sym.downcase).id) if place.try(&recipient.to_sym.downcase)
    end 
    recipients
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

end
