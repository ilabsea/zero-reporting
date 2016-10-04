class AddPlaceToReport < ActiveRecord::Migration
  def change
    add_reference :reports, :place, index: true
  end
end
