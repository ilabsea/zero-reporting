class AddDisabledToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :disabled, :boolean, default: false
  end
end
