class AddUrlReferenceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :url_ref, :string, defaults: nil
  end
end
