class ChangeColumnInVariables < ActiveRecord::Migration
  def change
    change_column :variables, :is_alerted_by_threshold, :boolean, :default => true
    change_column :variables, :is_alerted_by_report, :boolean, :default => false
  end
end
