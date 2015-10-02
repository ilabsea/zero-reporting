class CreateReportVariables < ActiveRecord::Migration
  def change
    create_table :report_variables do |t|
      t.references :report, index: true
      t.references :variable, index: true
      t.string :type
      t.string :value

      t.timestamps null: false
    end

    add_foreign_key :report_variables, :reports
    add_foreign_key :report_variables, :variables
  end
end
