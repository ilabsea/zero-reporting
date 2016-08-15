class ExternalSmsResult
  def initialize(setting, caller_phone, call_log_id)
    @setting = setting
    @caller_phone = caller_phone
    @call_log_id = call_log_id
  end

  def recipients
    @setting.recipients
  end

  def variables
    {
      caller_phone: @caller_phone,
      call_log_id: @call_log_id
    }
  end

  def run
    if @setting.enabled? && !recipients.empty?
      sms = Sms::Message.new(recipients, MessageTemplate.instance.set_source!(@setting.message_template).interpolate(variables), SmsType.verboice)

      SmsQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(sms.to_hash)
    end
  end
end
