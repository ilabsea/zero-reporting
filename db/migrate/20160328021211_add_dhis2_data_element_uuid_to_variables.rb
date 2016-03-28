class AddDhis2DataElementUuidToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :dhis2_data_element_uuid, :string, default: nil
  end
end
