class Od < ActiveRecord::Base
  belongs_to :phd
  validates :name, :code, :phd_id, presence: true
  validates :code, uniqueness: true
end
