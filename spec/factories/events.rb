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
#

FactoryGirl.define do
  factory :event do
		sequence(:description) { FFaker::Name.name }
		sequence(:from_date) { FFaker::Time.date }
		sequence(:to_date) { FFaker::Time.date }
		attachments { [build(:event_attachment)] }
  end

end
