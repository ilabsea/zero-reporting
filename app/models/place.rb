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
end
