module Auditor
  class Places::ReporterAuditor < PlaceAuditor
    def audit
      @places.each do |place|
        @setting.enables.each do |channel|
          alert = Parser::AlertParser.parse(channel, place, @setting)
          adapter = Parser::AlertAdapterParser.parse(channel, alert)
          adapter.process
        end
      end
    end
  end
end
