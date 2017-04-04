class AddAlertMethodToVariable < ActiveRecord::Migration
  def change
    add_column :variables, :alert_method, :string, default: :formula
  end
end
