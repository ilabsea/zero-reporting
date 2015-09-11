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
#

class Variable < ActiveRecord::Base
  validates :verboice_id, uniqueness: {scope: :verboice_project_id }

  has_many :report_variables
  has_many :reports, through: :report_variables

  def self.applied(project_id)
    where(verboice_project_id: project_id)
  end

  def self.save_from_params params
    project_id = params[:project]

    variables = params[:variable]
    verboice_ids = params[:project_variable_id]
    verboice_names = params[:project_variable_name]

    variables.each do |index, name|

      variable = Variable.where( verboice_id: verboice_ids[index],
                                 verboice_project_id: project_id).first_or_initialize

      if variable.persisted? && (name.blank? or verboice_ids[index].blank?)
        variable.destroy
        next
      end

      attrs = {
        name: name,
        description: name,
        verboice_name: verboice_names[index]
      }
      variable.update_attributes(attrs)
    end
  end
end
