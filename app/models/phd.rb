class Phd < ActiveRecord::Base
  has_many :ods
  validates :name, :code, presence: true
  validates :code, uniqueness: true
end
