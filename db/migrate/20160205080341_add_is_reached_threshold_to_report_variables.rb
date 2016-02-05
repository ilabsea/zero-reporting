class AddIsReachedThresholdToReportVariables < ActiveRecord::Migration
  def change
    add_column :report_variables, :is_reached_threshold, :boolean, default: false
  end
end
