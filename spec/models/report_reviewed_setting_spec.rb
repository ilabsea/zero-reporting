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

require 'rails_helper'

RSpec.describe ReportReviewedSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
