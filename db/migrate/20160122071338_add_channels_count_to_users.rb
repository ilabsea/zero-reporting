class AddChannelsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :channels_count, :integer
  end
end
