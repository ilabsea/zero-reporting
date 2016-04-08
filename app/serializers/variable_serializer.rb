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
