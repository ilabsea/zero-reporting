# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  kind_of    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#
# Indexes
#
#  index_places_on_ancestry  (ancestry)
#
require 'csv'

class Place < ActiveRecord::Base
  has_ancestry(orphan_strategy: :destroy)
  has_many :users

  validates :name, :code, presence: true
  validates :code, uniqueness: true


  PLACE_TYPE_PHD = 'PHD'
  PLACE_TYPE_OD  = 'OD'
  PLACE_TYPE_HC  = 'HC'

  before_save :set_my_type

  def set_my_type
    self.kind_of = my_type
  end

  def my_type
    if self.parent.present?
      (self.parent.is_kind_of_phd? ? Place::PLACE_TYPE_OD : Place::PLACE_TYPE_HC)
    else
      Place::PLACE_TYPE_PHD
    end
  end

  def is_kind_of_phd?
    self.kind_of == Place::PLACE_TYPE_PHD
  end

  def is_kind_of_od?
    self.kind_of == Place::PLACE_TYPE_OD
  end

  def is_kind_of_hc?
    self.kind_of == Place::PLACE_TYPE_HC
  end


  def od
    return nil if is_kind_of_phd?
    return self if is_kind_of_od?
    return self.parent if is_kind_of_hc?
  end

  def phd
    return self if is_kind_of_phd?
    return self.parent if is_kind_of_od?
    return self.parent.parent if is_kind_of_hc?
  end

  def hc
    return self if is_kind_of_hc?
    nil
  end

  def self.phds
    where([ "kind_of = ? AND ancestry is NULL ", Place::PLACE_TYPE_PHD ] )
  end

  def self.phds_list
    self.phds.pluck(:name, :id)
  end

  def self.ods_list(phd_id=nil)
    ods = where(["kind_of = ?", Place::PLACE_TYPE_OD])
    ods = ods.where(["ancestry = ?", phd_id]) if phd_id.present?
    ods.pluck(:name, :id)
  end

  def self.decode_hierarchy_csv(string)
    csv = CSV.parse(string)
    items = validate_format(csv)
    items.each do |order, item|
      if item[:parent].present? && !item[:error].present?
        parent_candidates = items.select{|key, hash| hash[:id] == item[:parent]}

        if parent_candidates.any?
          parent = parent_candidates.first[1]
        end

        if parent
          parent[:sub] ||= []
          parent[:sub] << item
        end
      end
    end
    items = items.reject do |order, item|
      if item[:parent] && !item[:error].present?
        item.delete :parent
        true
      else
        false
      end
    end
    items.values
    rescue Exception => ex
      return [{error: ex.message}]
  end

  def self.generate_error_description_location(locations_csv)
    locations_errors = []
    locations_csv.each do |item|
      message = ""

      if item[:error]
        message << "Error: #{item[:error]}"
        message << " " + item[:error_description] if item[:error_description]
        message << " in line #{item[:order]}." if item[:order]
      end

      locations_errors << message if !message.blank?
    end
    locations_errors.join("<br/>").to_s
  end

  def self.generate_error_description_list(hierarchy_csv)
    hierarchy_errors = []
    hierarchy_csv.each do |item|
      message = ""
      if item[:error]
        message << "Error: #{item[:error]}"
        message << " " + item[:error_description] if item[:error_description]
        message << " in line #{item[:order]}." if item[:order]
      end

      hierarchy_errors << message if !message.blank?
    end
    hierarchy_errors.join("<br/>").to_s
  end

  def self.validate_format(csv)
    i = 0
    items = {}
    csv.each do |row|
      item = {}
      if row[0] == 'ID'
        next
      else
        i = i+1
        item[:order] = i

        if row.length != 3
          item[:error] = "Wrong format."
          item[:error_description] = "Invalid column number"
        else

          #Check unique name
          name = row[2].strip
          if items.any?{|item| item.second[:name] == name}
            item[:error] = "Invalid name."
            item[:error_description] = "Hierarchy name should be unique"
            error = true
          end
          
          #Check unique id
          id = row[0].strip
          if items.any?{|item| item.second[:id] == id}
            item[:error] = "Invalid id."
            item[:error_description] = "Hierarchy id should be unique"
            error = true
          end

          #Check parent id exists
          parent_id = row[1]
          if(parent_id.present? && !csv.any?{|csv_row| csv_row[0].strip == parent_id.strip})
            item[:error] = "Invalid parent value."
            item[:error_description] = "ParentID should match one of the Hierarchy ids"
            error = true
          end

          if !error
            item[:id] = id
            item[:parent] = row[1].strip if row[1].present?
            item[:name] = name
          end
        end

        items[item[:order]] = item
      end
    end
    items
  end
end
