class AddColumnReviewedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reviewed, :boolean, default: false
  end
end
