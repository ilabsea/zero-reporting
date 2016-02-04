class AddVerboiceProjectIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :verboice_project_id, :integer
  end
end
