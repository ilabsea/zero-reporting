class AddExceedValueToReportVariable < ActiveRecord::Migration
  def change
    add_column :report_variables, :exceed_value, :string
  end
end
