# == Schema Information
#
# Table name: log_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  kind        :string(255)
#
# Indexes
#
#  index_log_types_on_kind  (kind)
#  index_log_types_on_name  (name) UNIQUE
#

FactoryGirl.define do
  factory :log_type do
    name "MyString"
  end

end
