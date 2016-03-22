# == Schema Information
#
# Table name: external_sms_settings
#
#  id                  :integer          not null, primary key
#  is_enable           :boolean
#  message_template    :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  recipients          :string(255)      default("--- []\n")
#

require 'rails_helper'

RSpec.describe ExternalSmsSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
