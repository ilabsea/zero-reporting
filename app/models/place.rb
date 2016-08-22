# == Schema Information
#
# Table name: places
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  code                         :string(255)
#  kind_of                      :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  ancestry                     :string(255)
#  dhis2_organisation_unit_uuid :string(255)
#  auditable                    :boolean          default(TRUE)
#
# Indexes
#
#  index_places_on_ancestry  (ancestry)
#

require 'csv'

class Place < ActiveRecord::Base
  include Places::Auditable
  
  has_ancestry(orphan_strategy: :destroy)

  self.inheritance_column = :kind_of

  has_many :users

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  # include kind_of as default self.class.inheritance_column was fully defaults include_root_in_json to false
  # read more: https://github.com/rails/rails/issues/3508
  def serializable_hash options=nil
    super.merge kind_of: kind
  end

  def kind
    self.class.kind
  end

  def self.kind
    self.name.split('::').last
  end

  def self.new_child
    PHD.new auditable: false
  end

  def new_child
    children.new(parent: self, kind_of: child_type, auditable: (child_type === HC.kind ? true : false))
  end

  def phd?
    kind_of === PHD.name
  end

  def od?
    kind_of === OD.name
  end

  def hc?
    kind_of == HC.name
  end

  def phd
    return self if phd?
    return parent if od?
    return parent.parent if hc?
  end

  def od
    return nil if phd?
    return self if od?
    return parent if hc?
  end

  def hc
    return self if hc?
    nil
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

        if row.length != 4
          item[:error] = "Wrong format."
          item[:error_description] = "Invalid column number"
        else

          #Check unique name
          name = row[2].strip
          # if items.any?{|item| item.second[:name] == name}
          #   item[:error] = "Invalid name."
          #   item[:error_description] = "Hierarchy name should be unique"
          #   error = true
          # end

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
            item[:level] = row[3].strip
          end
        end

        items[item[:order]] = item
      end
    end
    items
  end

  def self.generate_ancestry(code)
    parent = Place.find_by_code code
    if parent
      if parent.ancestry
        return parent.ancestry + "/" +parent.id.to_s
      else
        return parent.id.to_s
      end
    else
      nil
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['code', 'parent_code', 'name', 'level']
      where(kind_of: Place::Type::PHD).each do |phd|
        phd.with_hierarchy_to_csv csv
      end
    end
  end

  def with_hierarchy_to_csv csv
    csv << [phd.code, "", phd.name, phd.kind_of]
    children.each do |child|
      child.with_hierarchy_to_csv csv
    end
  end

  def has_dhis_location?
    dhis2_organisation_unit_uuid.present?
  end

  def self.level level = nil
    where(kind_of: level)
  end

  def self.levels levels = []
    where(kind_of: levels)
  end

  def self.in ids = []
    where(id: ids)
  end

  class Type
    def self.all
      [
        {code: PHD.kind, name: "Provincial Health Department", display_name: "Provincial Health Department of Health Centre Reporter"},
        {code: OD.kind, name: "Operational District", display_name: "Operation District of Health Centre Reporter"},
        {code: HC.kind, name: "Health Center", display_name: "Health Center Reporter"}
      ]
    end
  end
end
