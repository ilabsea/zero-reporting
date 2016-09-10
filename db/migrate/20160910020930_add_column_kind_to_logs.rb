class AddColumnKindToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :kind, :string, default: nil

    add_index :logs, :kind
  end
end
