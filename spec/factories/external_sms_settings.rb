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
#  recipients          :string(255)      default("--- []\n")
#

FactoryGirl.define do
  factory :external_sms_setting do
    is_enable false
message_template "MyString"
verboice_project_id 1
  end

end
