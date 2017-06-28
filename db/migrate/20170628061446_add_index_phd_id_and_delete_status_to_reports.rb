class AddIndexPhdIdAndDeleteStatusToReports < ActiveRecord::Migration
  def change
    add_index :reports, [:phd_id, :delete_status]
  end
end
