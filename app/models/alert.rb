# == Schema Information
#
# Table name: alerts
#
#  id                  :integer          not null, primary key
#  is_enable           :boolean
#  message_template    :string(255)
#  user_id             :integer
#  verboice_project_id :integer
#

class Alert < ActiveRecord::Base
  belongs_to :user
  serialize :recipient_type, Array
end
