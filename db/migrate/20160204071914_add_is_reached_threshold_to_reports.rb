class AddIsReachedThresholdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :is_reached_threshold, :boolean, default: false
  end
end
