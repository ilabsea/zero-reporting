class AddEmailPhoneRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :phone, :string
    add_column :users, :role, :string
  end
end
