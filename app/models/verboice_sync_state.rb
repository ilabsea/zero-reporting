# == Schema Information
#
# Table name: verboice_sync_states
#
#  id               :integer          not null, primary key
#  last_call_log_id :integer          default(-1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class VerboiceSyncState < ActiveRecord::Base
  def self.write call_log_id
    state = first_or_initialize
    if state.last_call_log_id < call_log_id
      state.last_call_log_id = call_log_id
      state.save
    end
  end
end
