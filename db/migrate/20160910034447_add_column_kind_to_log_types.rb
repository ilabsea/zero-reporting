class AddColumnKindToLogTypes < ActiveRecord::Migration
  def change
    add_column :log_types, :kind, :string, default: nil

    add_index :log_types, :kind
  end
end
