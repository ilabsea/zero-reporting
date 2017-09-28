class AddColumnOrdStatusToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ord, :integer
    add_column :events, :is_enabled, :boolean, default: false
  end
end
