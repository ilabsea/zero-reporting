class AddIsAlertedByReportToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :is_alerted_by_report, :boolean
  end
end
