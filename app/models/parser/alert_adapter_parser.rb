module Parser
  class AlertAdapterParser
    def self.parse channel, alert
      if channel.downcase === Alert::TYPES[:sms]
        adapter = Adapter::SmsAlertAdapter.new(alert)
      else
        adapter = Adapter::VoiceAlertAdapter.new(alert)
      end
      
      adapter
    end
  end
end
