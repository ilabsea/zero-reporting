class AddHasAudioColumnToReports < ActiveRecord::Migration
  def change
    add_column :reports, :has_audio, :boolean, default: false
  end
end
