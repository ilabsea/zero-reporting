class AddReportableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reportable, :boolean
  end
end
