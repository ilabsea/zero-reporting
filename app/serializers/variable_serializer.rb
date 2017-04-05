# == Schema Information
#
# Table name: variables
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  description             :string(255)
#  verboice_id             :integer
#  verboice_name           :string(255)
#  verboice_project_id     :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  background_color        :string(255)
#  text_color              :string(255)
#  is_alerted_by_threshold :boolean          default(TRUE)
#  is_alerted_by_report    :boolean          default(FALSE)
#  dhis2_data_element_uuid :string(255)
#  disabled                :boolean          default(FALSE)
#  alert_method            :string(255)      default("none")
#

class VariableSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :verboice_variable_id, :verboice_variable_name, :verboice_project_id, :dhis2_data_element_uuid,
            :text_color, :background_color, :created_at, :updated_at

  def verboice_variable_id
    object.verboice_id
  end

  def verboice_variable_name
    object.verboice_name
  end

end
