# == Schema Information
#
# Table name: alerts
#
#  id                    :integer          not null, primary key
#  is_enable_sms_alert   :boolean
#  message_template      :string(255)
#  user_id               :integer
#  verboice_project_id   :integer
#  is_enable_email_alert :boolean          default(FALSE)
#  recipient_type        :text(65535)
#

class Alert < ActiveRecord::Base
  belongs_to :user
  serialize :recipient_type, Array
end
