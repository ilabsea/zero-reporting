class AddFieldsToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :background_color, :string
    add_column :variables, :text_color, :string
  end
end
