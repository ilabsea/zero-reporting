# == Schema Information
#
# Table name: external_sms_settings
#
#  id                  :integer          not null, primary key
#  is_enable           :boolean
#  message_template    :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  recipients          :string(255)      default([])
#

class ExternalSmsSetting < ActiveRecord::Base
  validates :message_template, presence: true
  serialize :recipients, Array

  VARIABLES = %w(caller_phone call_log_id)

  def enabled?
    self.is_enable
  end
end
