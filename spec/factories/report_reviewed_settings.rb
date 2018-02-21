# == Schema Information
#
# Table name: report_reviewed_settings
#
#  id                  :integer          not null, primary key
#  endpoint            :string(255)
#  username            :string(255)
#  password            :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :report_reviewed_setting do
    sequence(:endpoint) { FFaker::Internet.http_url }
    sequence(:username) { FFaker::Name.name }
    sequence(:password) { FFaker::Name.name }
  end

end
