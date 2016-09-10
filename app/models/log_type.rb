# == Schema Information
#
# Table name: log_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_log_types_on_name  (name) UNIQUE
#

class LogType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :logs, class_name: "SmsLog", foreign_key: :type_id, dependent: :nullify

  def self.alert
    where(name: :alert).first
  end

  def self.broadcast
    where(name: :broadcast).first
  end

  def self.notify
    where(name: :notify).first
  end

  def self.reminder
    where(name: :reminder).first
  end

  def self.reminder_call
    where(name: :reminder_call).first
  end

end
