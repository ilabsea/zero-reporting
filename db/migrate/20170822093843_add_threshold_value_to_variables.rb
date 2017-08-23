class AddThresholdValueToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :threshold_value, :integer, default: 0
  end
end
