# == Schema Information
#
# Table name: sms_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sms_types_on_name  (name) UNIQUE
#

class SmsType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :logs, class_name: "SmsLog", foreign_key: :type_id, dependent: :nullify

  def self.alert
    where(name: :alert).first
  end

  def self.broadcast
    where(name: :broadcast).first
  end

  def self.verboice
    where(name: :verboice).first
  end
end
