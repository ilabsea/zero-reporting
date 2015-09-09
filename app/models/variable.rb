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
  

  def self.save_from_params params
    project_id = params[:project]

    variables = params[:variable]
    verboice_ids = params[:project_variable_id]
    verboice_names = params[:project_variable_name]

    variables.each do |index, name|
      next if name.blank? or verboice_ids[index].blank?
      variable = Variable.where( verboice_id: verboice_ids[index],
                                 verboice_project_id: project_id).first_or_initialize
      attrs = {
        name: name,
        description: name,
        verboice_name: verboice_names[index]
      }
      variable.update_attributes(attrs)
    end
  end
end
