module Auditor
  class Places::ReporterAuditor < PlaceAuditor
    def audit
      @places.each do |place|
        @setting.enables.each do |channel|
          alert = Parser::AlertParser.parse(channel, place, @setting)
          alert_context = Parser::AlertContextParser.parse(channel, alert)
          alert_context.process
        end
      end
    end
  end
end
