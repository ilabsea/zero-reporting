module Adapter
  class SmsAlertAdapter
    def initialize alert
      @alert = alert
    end

    def process
      return if !@alert.enabled? || !@alert.has_recipients?

      # variables didn't load in MessageTemplate => such a bug
      variables = @alert.variables

      message = MessageTemplate.instance.set_source!(@alert.message_template).interpolate(variables)
      @alert.recipients.each do |recipient|
        suggested_channel = Channel.suggested(Tel.new(recipient))

        sms = Sms::Message.new(recipient, message, suggested_channel, @alert.type)
        SmsQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(sms.to_hash)
      end
    end
  end
end
