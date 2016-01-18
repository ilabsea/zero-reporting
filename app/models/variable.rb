# == Schema Information
#
# Table name: variables
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)
#  verboice_id         :integer
#  verboice_name       :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  background_color    :string(255)
#  text_color          :string(255)
#

class Variable < ActiveRecord::Base
  validates :verboice_id, uniqueness: {scope: :verboice_project_id, message: 'variable has already been taken' }

  has_many :report_variables, dependent: :nullify
  has_many :reports, through: :report_variables

  def self.applied(project_id)
    where(verboice_project_id: project_id)
  end

end
