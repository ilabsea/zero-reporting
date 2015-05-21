class AddPhoneWithoutPrfixToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_without_prefix, :string
  end
end
