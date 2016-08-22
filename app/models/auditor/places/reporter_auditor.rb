module Auditor
  class Places::ReporterAuditor < PlaceAuditor
    def audit
      @places.each do |place|
        place_alert = Alert::Place::ReporterAlert.new place, @setting
        context = Contexts::AlertContext.new(place_alert)
        context.process
      end
    end
  end
end
