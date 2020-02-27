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

  MODE_MOVING = 'moving'

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
    csv << [self.code, "", self.name, self.kind_of]
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
