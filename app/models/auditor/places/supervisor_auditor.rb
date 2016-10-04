module Auditor
  class Places::SupervisorAuditor < PlaceAuditor
    def audit
      ancestry_places = @places.group(:ancestry).select(:ancestry)
      ancestry_places.each do |ancestry_place|
        if ancestry_place
          place = Place.find(ancestry_place.ancestry.split('/').last)
          child_places = @places.where(ancestry: ancestry_place.ancestry)
          
          place_alert = Alerts::Place::SupervisorAlert.new place, @setting, child_places
          adapter = Adapter::SmsAlertAdapter.new(place_alert)
          adapter.process
        end
      end
    end
  end
end
