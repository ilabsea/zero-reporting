# == Schema Information
#
# Table name: sms_recipients
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  phone               :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  verboice_project_id :integer
#

require 'rails_helper'

RSpec.describe SmsRecipient, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
