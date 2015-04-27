class Member < ActiveRecord::Base
  belongs_to :od
  belongs_to :phd

  validates :name, :phone, :phd_id, :od_id, presence: true

  def od_list
    if self.phd_id.present?
      Od.order('name DESC').where(phd_id: self.phd_id).pluck(:name, :id)
    else
      []
    end
  end
end
