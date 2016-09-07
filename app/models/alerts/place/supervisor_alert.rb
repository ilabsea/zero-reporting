module Alerts
  class Place::SupervisorAlert < PlaceAlert
    def initialize place, setting, child_places
      super(place, setting)
      @child_places = child_places
    end

    def enabled?
      super && (@setting.has_recipient?(OD.kind) || @setting.has_recipient?(PHD.kind)) && !@child_places.empty?
    end

    def message_template
      @setting.templates[Alert::TYPES[:sms]].supervisor
    end

    def variables
      {
        x_week: @setting.x_week,
        place_name: @child_places.pluck(:name).join(', ')
      }
    end
  end
end
