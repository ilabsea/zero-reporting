# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  description :text(65535)
#  from_date   :date
#  to_date     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  url_ref     :string(255)
#

FactoryGirl.define do
  factory :event do
		sequence(:description) { FFaker::Name.name }
		sequence(:from_date) { FFaker::Time.date }
		sequence(:to_date) { FFaker::Time.date }
    sequence(:url_ref) { FFaker::Internet.http_url }
		attachments { [build(:event_attachment)] }
  end

end
