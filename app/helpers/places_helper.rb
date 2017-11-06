module PlacesHelper
  def user_hierarchy_to_csv place, csv
    place.users.each do |user|
      if Setting.hub_enabled?
        csv << [place.kind_of, place.code, place.dhis2_organisation_unit_uuid, place.name, user.phone, user.name]
      else
        csv << [place.kind_of, place.code, place.name, user.phone, user.name]
      end
    end

    place.children.each do |child_place|
      user_hierarchy_to_csv child_place, csv
    end
  end

  def place_hierarchy_to_csv place, csv
    if Setting.hub_enabled?
      csv << [place.code, place.parent.try(:code), place.dhis2_organisation_unit_uuid, place.name, place.kind_of]
    else
      csv << [place.code, place.parent.try(:code), place.name, place.kind_of]
    end

    place.children.each do |child_place|
      place_hierarchy_to_csv child_place, csv
    end
  end

  def tree_for places, active_place_id=nil
    if !active_place_id.present?
      active_root = 'active'
      selected_class = 'selected'
    else
      active_root = ''
      selected_class = ''
    end

    content_tag(:li, class: "tree-node-wrapper #{active_root}", id: 'tree-root') do
      link_to("Cambodia", users_path, class: "tree-node #{selected_class}", data: {id: ''}) + content_tag(:ul, children_tree_for(places, active_place_id))
    end
  end

  def children_tree_for places, active_place_id=nil
    places.map do |place, children|
      selected_class = (place.id == active_place_id.to_i ? 'selected' : '')

      item = link_to("#{place.kind} - #{place.name} (#{place.code}) ", users_path(place_id: place.id ),
                     class: "tree-node #{selected_class}",
                     data: {id: place.id})

      if place.has_dhis_location?
        item += content_tag(:i, '', class: "glyphicon glyphicon-link")
        item += " #{place.dhis2_organisation_unit_uuid}"
      end

      if place.movable?
        item += link_to 'move', edit_place_path(place, state: Place::MODE_MOVING)
      end

      item += content_tag(:ul, children_tree_for(children, active_place_id)) if children.size > 0

      expanded_class = (!place.parent || place.id == active_place_id.to_i) ? 'active' : ''
      content_tag(:li, item, class: "tree-node-wrapper #{expanded_class}")

    end.join('').html_safe
  end

  def display_parent_for place
    content_tag :p, parent_for(place).reverse.join("<br/>").html_safe, class: 'p-desc'
  end

  def parent_for place
    result = []
    if place.parent
      text = "#{place.parent.kind} - #{place.parent.name} ( #{place.parent.code} )"
      result << text
      result += parent_for(place.parent)
    end
    result
  end

  def display_hierachy_for place
    content_tag :p, hierachy_for(place).reverse.join("<br />").html_safe, class: 'p-desc'
  end

  def hierachy_for place
    result = []
    if place
      text = "#{place.kind} - #{place.name} ( #{place.code} )"
      result << text
      result += hierachy_for(place.parent)
    end
    result
  end

end
