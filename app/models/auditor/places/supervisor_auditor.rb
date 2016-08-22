module Auditor
  class Places::SupervisorAuditor < PlaceAuditor
    def audit
      ancestry_places = @places.group(:ancestry).select(:ancestry)
      ancestry_places.each do |ancestry_place|
        if ancestry_place
          place = Place.find(ancestry_place.ancestry.split('/').last)
          child_places = @places.where(ancestry: ancestry_place.ancestry)
          
          place_alert = Alert::Place::SupervisorAlert.new place, @setting, child_places
          context = Contexts::AlertContext.new(place_alert)
          context.process
        end
      end
    end
  end
end
