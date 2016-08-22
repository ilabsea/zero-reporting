class AddAuditableToPlace < ActiveRecord::Migration
  def change
    add_column :places, :auditable, :boolean, index: true, default: true
  end
end
