FactoryGirl.define do
  factory :alert do
    is_enable_sms_alert false
    is_enable_email_alert false
    message_template "String"
    verboice_project_id 1
    recipient_type []
  end

end
