class PlaceCSV
  def initialize(csv_string)
    @csv_string = CSV.parse(csv_string)
    @places = {}
  end

  def import
    data = []
    @csv_string.each_with_index do |item, index|
      next if index == 0
      parent = item[1].present? ? Place.generate_ancestry(item[1].strip) : nil
      place = Place.create!(:name => item[2].strip, :code => item[0].strip, :kind_of => item[3].strip, :ancestry => parent)
      data.push(place)
    end
    return {data: data, row_imported: data.length}
  end

  def decode
    parse_with_validation
    return @places.values
    rescue Exception => ex
      return [{error: ex.message}]
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
      if place[:parent].present? && !place[:error].present?
        parent_candidates = @places.select{|key, hash| hash[:id] == place[:parent]}
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
      place.delete(:parent) if place[:parent] && !place[:error].present?
    end
  end

  def parse_with_validation
    @csv_string.each_with_index do |row, index|
      next if index == 0
      item = {}
      item[:ord] = index

      valid = valid_csv_column?(row)
      if(valid)
        name = row[2].strip
        id = row[0].strip
        parent_id = row[1].present? ? row[1].strip : ""

        valid = valid_id?(id)
        if(!valid)
          item[:error] = "Invalid id."
          item[:error_description] = "Place id should be unique"
        end

        valid = valid_ancestry?(parent_id)
        if(!valid)
          item[:error] = "Invalid parent value."
          item[:error_description] = "ParentID should match one of the Hierarchy ids"
        end

        if (valid)
          item[:id] = id
          item[:parent] = parent_id if parent_id != ""
          item[:name] = name
          item[:level] = row[3].strip
        end
      else
        item[:error] = "Wrong format."
        item[:error_description] = "Invalid column number"
      end
      @places[item[:ord]] = item
    end

    build_hierarchy
  end

  def valid_csv_column?(item_cols)
    return item_cols.length == 4 ? true : false
  end

  def valid_id?(id)
    return (@places.any?{ |place| place.second[:id] == id }) ? false : true
  end

  def valid_ancestry?(parent_id)
    return (parent_id.present? && !@csv_string.any?{|row| row[0].strip == parent_id.strip}) ? false : true
  end

end
