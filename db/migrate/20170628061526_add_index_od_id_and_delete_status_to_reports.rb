class AddIndexOdIdAndDeleteStatusToReports < ActiveRecord::Migration
  def change
    add_index :reports, [:od_id, :delete_status]
  end
end
