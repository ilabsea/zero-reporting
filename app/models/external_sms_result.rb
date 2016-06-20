class ExternalSmsResult
  def initialize(setting, caller_phone, call_log_id)
    @setting = setting
    @caller_phone = caller_phone
    @call_log_id = call_log_id
  end

  def recipients
    @setting.recipients
  end

  def to_sms_message
    Sms::Message.new(recipients, interpolate_variable_values)
  end

  def interpolate_variable_values
    variable_values = {
      caller_phone: @caller_phone,
      call_log_id: @call_log_id
    }

    MessageTemplate.instance.set_source!(@setting.message_template).interpolate(variable_values)
  end

  def run
    if @setting.enabled? && !recipients.empty?
      SmsQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(to_sms_message.to_hash)
    end
  end
end
