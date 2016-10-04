module Parser
  class AlertParser
    def self.parse channel, place, setting
      if (channel === Alert::TYPES[:sms])
        alert = Alerts::Place::ReporterAlert.new(place, setting)
      else
        alert = Alerts::VoiceAlert.new place, setting
      end

      alert
    end
  end
end
