class AddIsDefaultToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :is_default, :boolean, default: false
  end
end
