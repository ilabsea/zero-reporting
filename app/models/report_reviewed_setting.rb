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

class ReportReviewedSetting < ActiveRecord::Base

  validates_presence_of :endpoint

  def notify(report)
    Typhoeus.post(self.endpoint, body: JSON.generate(report), userpwd: "#{self.username}:#{self.password}",
                  headers: {'content-type' => 'application/json'} )
  end
end
