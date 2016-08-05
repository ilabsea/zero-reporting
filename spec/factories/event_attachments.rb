# == Schema Information
#
# Table name: event_attachments
#
#  id         :integer          not null, primary key
#  file       :string(255)
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_attachments_on_event_id  (event_id)
#

FactoryGirl.define do
  factory :event_attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.pdf')) }
		sequence(:event_id) { 1 + rand(10) }
  end

end
