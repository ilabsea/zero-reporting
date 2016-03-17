class AddVerboiceProjectIdToSmsRecipients < ActiveRecord::Migration
  def change
    add_column :sms_recipients, :verboice_project_id, :integer
  end
end
