module Parser
  class AlertContextParser
    def self.parse channel, alert
      if channel.downcase === Alert::TYPES[:sms]
        context = Contexts::SmsAlertContext.new(alert)
      else
        context = Contexts::VoiceAlertContext.new(alert)
      end
      
      context
    end
  end
end
