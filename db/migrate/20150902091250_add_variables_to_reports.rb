class AddVariablesToReports < ActiveRecord::Migration
  def change
    add_column :reports, :call_log_answers, :text
  end
end
