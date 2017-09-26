class RenameColumnsInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :from_date, :display_from
    rename_column :events, :to_date, :display_till
  end
end
