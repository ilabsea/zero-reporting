# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  description  :text(65535)
#  display_from :date
#  display_till :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  url_ref      :string(255)
#  ord          :integer
#  is_enabled   :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :event do
		sequence(:description) { FFaker::Name.name }
		sequence(:display_from) { FFaker::Time.date }
		sequence(:display_till) { FFaker::Time.date }
    sequence(:url_ref) { FFaker::Internet.http_url }
		attachments { [build(:event_attachment)] }
  end

end
