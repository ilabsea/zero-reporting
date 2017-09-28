class ChangeBodyTypeInLogs < ActiveRecord::Migration
  def change
    change_column :logs, :body, :text
  end
end
