class AddDhis2OrganisationUnitUuidToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :dhis2_organisation_unit_uuid, :string, default: nil
  end
end
