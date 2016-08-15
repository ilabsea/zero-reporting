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

FactoryGirl.define do
  factory :sms_type do
    name "MyString"
  end

end
