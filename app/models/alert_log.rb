# == Schema Information
#
# Table name: alert_logs
#
#  id                  :integer          not null, primary key
#  from                :string(255)
#  to                  :string(255)
#  body                :string(255)
#  suggested_channel   :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class AlertLog < ActiveRecord::Base
end
