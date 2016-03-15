class RenameIsReachedThresholdInReportVariables < ActiveRecord::Migration
  def change
    rename_column :report_variables, :is_reached_threshold, :is_alerted
  end
end
