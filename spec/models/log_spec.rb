# == Schema Information
#
# Table name: logs
#
#  id          :integer          not null, primary key
#  model       :text(65535)
#  model_class :string(255)
#  type_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Log, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
