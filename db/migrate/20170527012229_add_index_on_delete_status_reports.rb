class AddIndexOnDeleteStatusReports < ActiveRecord::Migration
  def change
    add_index :reports, [:delete_status]
  end
end
