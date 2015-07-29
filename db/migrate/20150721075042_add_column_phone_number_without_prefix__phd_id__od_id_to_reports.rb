class AddColumnPhoneNumberWithoutPrefixPhdIdOdIdToReports < ActiveRecord::Migration
  def change
    rename_column :reports, :phone_number, :phone
    rename_column :reports, :audio, :audio_key
    add_column :reports, :phone_without_prefix, :string
    add_column :reports, :phd_id, :integer
    add_column :reports, :od_id, :integer
    add_column :reports, :status, :string
    add_column :reports, :duration, :float
    add_column :reports, :started_at, :datetime
    add_column :reports, :call_flow_id, :integer
    add_column :reports, :recorded_audios, :text
  end
end
