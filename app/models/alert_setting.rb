# == Schema Information
#
# Table name: alert_settings
#
#  id                    :integer          not null, primary key
#  is_enable_sms_alert   :boolean
#  message_template      :string(255)
#  verboice_project_id   :integer
#  is_enable_email_alert :boolean          default(FALSE)
#  recipient_type        :text(65535)
#

class AlertSetting < ActiveRecord::Base
  serialize :recipient_type, Array

  def self.get(project_id)
    AlertSetting.find_by(verboice_project_id: project_id)
  end

  def self.has_alert?(project_id)
    get(project_id).present?
  end
end
