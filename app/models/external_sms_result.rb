class ExternalSmsResult
  def initialize(caller_phone, call_log_id)
    @caller_phone = caller_phone
    @call_log_id = call_log_id
  end

  def self.recipients
    SmsRecipient.where(verboice_project_id: Setting[:project])
  end

  def message_options
    options = []
    ExternalSmsResult.recipients.each do |recipient|
      suggested_channel = Channel.suggested(Tel.new(recipient.phone))
      if suggested_channel
        option = {from: ENV['APP_NAME'],
                  to: "sms://#{recipient.phone}",
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
    MessageTemplate.instance.set_source(ENV['EXTERNAL_MESSAGE_TEMPLATE']).translate(translate_options)
  end

  def run
    external_sms_setting = ExternalSmsSetting.find_by(verboice_project_id: Setting[:project])
    if external_sms_setting.is_enable && !message_options.empty?
      SmsAlertJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(self.message_options)
    end
  end
end
