# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :string(255)
#  name                 :string(255)
#  password_digest      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :string(255)
#  phone                :string(255)
#  role                 :string(255)
#  place_id             :integer
#  phone_without_prefix :string(255)
#  phd_id               :integer
#  od_id                :integer
#  channels_count       :integer
#  sms_alertable        :boolean          default(TRUE)
#  disable_alert_reason :string(255)
#  reportable           :boolean
#
# Indexes
#
#  index_users_on_place_id  (place_id)
#

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user_#{n}"}
    password "123456"
    sequence(:name) {|n| "User_#{n}"}
    sequence(:phone) {|n| "100#{n}"}
    place { create(:phd)}
    sms_alertable true
  end

end
