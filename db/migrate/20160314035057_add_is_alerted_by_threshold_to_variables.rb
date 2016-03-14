class AddIsAlertedByThresholdToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :is_alerted_by_threshold, :boolean
  end
end
