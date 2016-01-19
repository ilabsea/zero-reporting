class AddYearWeekAndReviewedAtToReports < ActiveRecord::Migration
  def change
    add_column :reports, :year, :integer, defaults: nil
    add_column :reports, :week, :integer, defaults: nil
    add_column :reports, :reviewed_at, :datetime, defaults: nil

    add_index :reports, [:year, :week]
  end
end
