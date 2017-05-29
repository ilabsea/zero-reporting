# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  password   :string(255)
#  setup_flow :string(255)
#  is_enable  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_default :boolean          default(FALSE)
#
# Indexes
#
#  index_channels_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :channel do
    name "MyString"
    password "MyString"
    setup_flow "MyString"
  end

end
