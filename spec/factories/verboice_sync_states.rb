# == Schema Information
#
# Table name: verboice_sync_states
#
#  id               :integer          not null, primary key
#  last_call_log_id :integer          default(-1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :verboice_sync_state do
    call_log_id 1
  end

end
