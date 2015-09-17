class AddTokenToReportVariables < ActiveRecord::Migration
  def change
    add_column :report_variables, :token, :string, index: true
  end
end
