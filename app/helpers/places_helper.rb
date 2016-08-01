module PlacesHelper
  def user_hierarchy_to_csv place, csv
    place.users.each do |user|
      csv << [place.kind_of, place.code, place.dhis2_organisation_unit_uuid, place.name, user.phone, user.name]
    end

    place.children.each do |child_place|
      user_hierarchy_to_csv child_place, csv
    end
  end

  def place_hierarchy_to_csv place, csv
    csv << [place.code, place.parent.try(:code), place.dhis2_organisation_unit_uuid, place.name, place.kind_of]

    place.children.each do |child_place|
      place_hierarchy_to_csv child_place, csv
    end
  end
end
