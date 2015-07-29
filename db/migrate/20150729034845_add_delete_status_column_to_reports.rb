class AddDeleteStatusColumnToReports < ActiveRecord::Migration
  def change
    add_column :reports, :delete_status, :boolean, default: false
  end
end
