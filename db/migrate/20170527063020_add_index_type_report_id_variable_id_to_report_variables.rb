class AddIndexTypeReportIdVariableIdToReportVariables < ActiveRecord::Migration
  def change
    add_index :report_variables, [:report_id, :variable_id, :type]
  end
end
