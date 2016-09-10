# == Schema Information
#
# Table name: sms_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sms_types_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe LogType, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
