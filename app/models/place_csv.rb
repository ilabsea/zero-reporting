class PlaceCSV
  def initialize(csv_string)
    @csv_string = CSV.parse(csv_string)
    @places = {}
  end

  def import
    data = []
    row_imported = 0
    @csv_string.each_with_index do |item, index|
      next if index == 0

      code = item[0].present? ? item[0].strip : ""
      parent = item[1].present? ? Place.generate_ancestry(item[1].strip) : nil
      name = item[2].present? ? item[2].strip : ""
      kind_of = item[3].present? ? item[3].strip : ""
      place = Place.new(:name => name, :code => code, :kind_of => kind_of, :ancestry => parent)

      next if parent.nil? && item[1].present? # ignore place with invalid ancestry

      if place.save
        data.push(place)
        row_imported = row_imported + 1
      end
    end
    return {data: data, row_imported: row_imported}
  end

  def decode
    parse_with_validation
    @places.values
  end

  def generate_error_description_list
    hierarchy_errors = []
    @places.each do |ord, place|
      message = ""
      if place[:error]
        message << "Error: #{place[:error]}"
        message << " " + place[:error_description] if place[:error_description]
        message << " in line #{place[:order]}." if place[:order]
      end

      hierarchy_errors << message if !message.blank?
    end
    hierarchy_errors.join("<br/>").to_s
  end

  private
  def build_hierarchy
    @places.each do |ord, place|
      if place[:parent_id].present?
        parent_candidates = @places.select{|key, item| item[:id] == place[:parent_id]}
        parent = parent_candidates.first[1] if parent_candidates.any?
        if parent
          parent[:sub] ||= []
          parent[:sub] << place
        end
      end
    end
    remove_ancestry
  end


  def remove_ancestry
    @places = @places.reject do |ord, place|
      is_descendant_of?(place[:parent_id])
    end
  end

  def parse_with_validation

    @csv_string.each_with_index do |row, index|

      next if index == 0
      item = {}
      item[:ord] = index
      item[:errors] = []

      if(valid_csv_column?(row))
        item[:id] = row[0].strip
        item[:parent_id] = row[1].present? ? row[1].strip : ""
        item[:name] = row[2].present? ? row[2].strip : ""
        item[:level] = row[3].strip

        ancestry = item[:parent_id] == '' ? nil : generate_ancestry(item[:parent_id])
        new_place = Place.new(name: item[:name], code: item[:id])

        if !new_place.valid?
          new_place.ancestry = ancestry
          item[:errors].push(new_place.errors.messages)
        end

        if ancestry.nil? && item[:parent_id] != ''
          item[:errors].push({ancestry: ['is invalid']})
        end

      else
        item[:errors].push({:type => 'invalid column number', :field => 'format'})
      end
      @places[item[:ord]] = item
    end

    build_hierarchy
  end

  def valid_csv_column?(item_cols)
    return item_cols.length == 4 ? true : false
  end

  def generate_ancestry(place_id)
    @places.select{|key, item| item[:id] == place_id && item[:errors].length == 0}.first || Place.find_by_code(place_id)
  end

  def is_descendant_of?(place_parent_id)
    return false if place_parent_id == ''
    parent = @places.select{|key, item| item[:id] == place_parent_id}.first
    return parent ? true : false
  end

end
