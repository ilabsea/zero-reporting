# == Schema Information
#
# Table name: sms_recipients
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  phone               :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  verboice_project_id :integer
#

class SmsRecipient < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :phone, uniqueness: true
end
