# == Schema Information
#
# Table name: telegram_bots
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  username   :string(255)
#  enabled    :boolean          default(FALSE)
#  actived    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :telegram_bot do
    
  end

end
