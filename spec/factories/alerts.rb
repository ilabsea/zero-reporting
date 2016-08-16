# == Schema Information
#
# Table name: alerts
#
#  id                    :integer          not null, primary key
#  is_enable_sms_alert   :boolean
#  message_template      :string(255)
#  verboice_project_id   :integer
#  is_enable_email_alert :boolean          default(FALSE)
#  recipient_type        :text(65535)
#

FactoryGirl.define do
  factory :alert do
    is_enable_sms_alert false
    is_enable_email_alert false
    message_template "String"
    verboice_project_id 1
    recipient_type []
  end

end
