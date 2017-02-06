class AddIndexOfReviewedReport < ActiveRecord::Migration
  def change
    add_index :reports, [:place_id, :year, :week, :reviewed, :delete_status], name: 'index_reports_on_weekly_reviewed'
  end
end
