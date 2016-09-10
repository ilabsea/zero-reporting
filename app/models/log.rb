# == Schema Information
#
# Table name: logs
#
#  id                  :integer          not null, primary key
#  from                :string(255)
#  to                  :text(65535)
#  body                :string(255)
#  suggested_channel   :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type_id             :integer
#  kind                :string(255)
#  started_at          :datetime
#
# Indexes
#
#  index_logs_on_kind     (kind)
#  index_logs_on_type_id  (type_id)
#

class Log < ActiveRecord::Base
  default_scope { includes(:type) }

  belongs_to :type, class_name: "LogType"

  def self.write_sms(sms)
    options = { to: sms.to, body: sms.body, suggested_channel: sms.suggested_channel.try(:name), started_at: Time.now, type: sms.type, kind: :sms}
    options[:verboice_project_id] = Setting[:project].to_i if Setting[:project].present?
    Log.create! options
  end

  def self.write_call(call)
    options = { to: call.receivers.join(', '), body: call.call_flow_id, suggested_channel: call.channel_id, started_at: call.not_before, type: call.type, kind: :voice}
    options[:verboice_project_id] = Setting[:project].to_i if Setting[:project].present?
    Log.create! options
  end

end
