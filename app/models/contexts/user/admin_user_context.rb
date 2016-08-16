module Contexts
  class User::AdminUserContext < UserContext
    def reports
      Report.all
    end

    def phds_list
      PHD.all.pluck(:name, :id)
    end

    def ods_list(place_id)
      place_id.present? ? Place.find(place_id).children.pluck(:name, :id) : []
    end
  end
end
