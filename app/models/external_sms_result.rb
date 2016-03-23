class ExternalSmsResult
  def initialize(setting, caller_phone, call_log_id)
    @setting = setting
    @caller_phone = caller_phone
    @call_log_id = call_log_id
  end

  def recipients
    @setting.recipients
  end

  def message_options
    options = []
    self.recipients.each do |phone|
      suggested_channel = Channel.suggested(Tel.new(phone))
      if suggested_channel
        option = {from: ENV['APP_NAME'],
                  to: "sms://#{phone}",
                  body: translate_message,
                  suggested_channel: suggested_channel.name}
        options << option
      end
    end
    options
  end

  def translate_message
    translate_options = {
      caller_phone: @caller_phone,
      call_log_id: @call_log_id
    }
    MessageTemplate.instance.set_source(@setting.message_template).translate(translate_options)
  end

  def run
    if @setting.is_enable && !message_options.empty?
      SmsAlertJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(self.message_options)
    end
  end
end
