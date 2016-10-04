# == Schema Information
#
# Table name: logs
#
#  id                  :integer          not null, primary key
#  from                :string(255)
#  to                  :text(65535)
#  body                :string(255)
#  suggested_channel   :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type_id             :integer
#  kind                :string(255)
#  started_at          :datetime
#
# Indexes
#
#  index_logs_on_kind     (kind)
#  index_logs_on_type_id  (type_id)
#

FactoryGirl.define do
  factory :log do
    from "MyString"
    to "MyString"
    body "MyString"
    suggested_channel "MyString"
    verboice_project_id 1
  end
end
