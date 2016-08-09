class AlertCase
  def initialize(alert, report, week)
    @alert = alert
    @report = report
    @week = week
    @alerted_variables = @report.alerted_variables
  end

  def run
    return if @alert.is_enable_sms_alert == false || @alerted_variables.empty?

    SmsQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(to_sms_message.to_hash)
  end

  def to_sms_message
    message_body = interpolate_variable_values
    receivers = recipients.map { |user| user.phone if user.phone.present? }.compact
    Sms::Message.new(receivers, message_body)
  end

  def recipients
    recipients = []

    place = @report.user.place
    @alert.recipient_type.each do |recipient|
      recipients = recipients + User.by_place(place.try(&recipient.to_sym.downcase).id) if place.try(&recipient.to_sym.downcase)
    end
    recipients
  end

  def interpolate_variable_values
    return "" unless @alert.message_template

    reported_cases = @alerted_variables.map { |rv| {name: rv.name, value: rv.value, exceed_value: rv.exceed_value} }

    variable_values = {
      week_year: @week.display(Calendar::Week::DISPLAY_NORMAL_MODE, "ww-yyyy"),
      reported_cases: MessageTemplate.instance.set_source!(ENV['REPORTED_CASE_ALERT_TEMPLATE']).interpolate_reported_cases(reported_cases).join(" , "),
      place_name: @report.place.name
    }

    return MessageTemplate.instance.set_source!(@alert.message_template).interpolate(variable_values)
  end

end
