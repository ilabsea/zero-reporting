class AddHasAudioToReportVariables < ActiveRecord::Migration
  def change
    add_column :report_variables, :has_audio, :boolean, default: false
    add_column :report_variables, :listened, :boolean, default: false
  end
end
