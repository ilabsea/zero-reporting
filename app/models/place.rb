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
end
