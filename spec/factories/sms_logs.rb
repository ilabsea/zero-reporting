# == Schema Information
#
# Table name: sms_logs
#
#  id                  :integer          not null, primary key
#  from                :string(255)
#  to                  :string(255)
#  body                :string(255)
#  suggested_channel   :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type_id             :integer
#
# Indexes
#
#  index_sms_logs_on_type_id  (type_id)
#

FactoryGirl.define do
  factory :sms_log do
    from "MyString"
    to "MyString"
    body "MyString"
    suggested_channel "MyString"
    verboice_project_id 1
  end
end
