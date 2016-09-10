# == Schema Information
#
# Table name: sms_logs
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
#  index_sms_logs_on_type_id  (type_id)
#

class SmsLog < ActiveRecord::Base
  default_scope { includes(:type) }

  belongs_to :type, class_name: "SmsType"

  def self.write(sms)
    SmsLog.create sms.to_nuntium_params.merge(type: sms.type)
  end

end
