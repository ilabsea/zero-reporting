# == Schema Information
#
# Table name: logs
#
#  id                  :integer          not null, primary key
#  from                :string(255)
#  to                  :string(255)
#  body                :string(255)
#  suggested_channel   :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type_id             :integer
#
# Indexes
#
#  index_logs_on_type_id  (type_id)
#

class Log < ActiveRecord::Base
  default_scope { includes(:type) }

  belongs_to :type, class_name: "LogType"

  def self.write_sms(sms)
    options = { to: sms.to, body: sms.body, suggested_channel: sms.suggested_channel.name, type: sms.type}
    options[:verboice_project_id] = Setting[:project].to_i if Setting[:project].present?
    Log.create! options
  end

  def self.write_call(call)
    options = { to: call.receivers.join(', '), body: call.call_flow_id, suggested_channel: call.channel_id, type: call.type}
    options[:verboice_project_id] = Setting[:project].to_i if Setting[:project].present?
    Log.create! options
  end

end
