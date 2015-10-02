class AddVerboiceProjectIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :verboice_project_id, :integer
  end
end
