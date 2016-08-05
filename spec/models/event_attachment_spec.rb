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

require 'rails_helper'

RSpec.describe EventAttachment, type: :model do
	it { should belong_to(:event) }
end
