class ChangeVariablesDefaultAlertMethod < ActiveRecord::Migration
  def change
    change_column_default(:variables, :alert_method, 'none')
  end
end
