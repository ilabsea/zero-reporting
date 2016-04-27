class AddDhis2AttributesToReports < ActiveRecord::Migration
  def change
    add_column :reports, :dhis2_submitted, :boolean, default: false
    add_column :reports, :dhis2_submitted_at, :datetime, default: nil
    add_column :reports, :dhis2_submitted_by, :integer, default: nil
  end
end
