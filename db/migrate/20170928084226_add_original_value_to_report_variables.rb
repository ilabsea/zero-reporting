class AddOriginalValueToReportVariables < ActiveRecord::Migration
  def change
    add_column :report_variables, :original_value, :string
  end
end
