# == Schema Information
#
# Table name: places
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  code                         :string(255)
#  kind_of                      :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  ancestry                     :string(255)
#  dhis2_organisation_unit_uuid :string(255)
#
# Indexes
#
#  index_places_on_ancestry  (ancestry)
#

require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'create' do
    context 'with no parent place' do
      it 'set place type to PHD' do
        place = create(:place, kind_of: Place::PLACE_TYPE_PHD)
        expect(place.is_kind_of_phd?).to be true
      end
    end

    context 'with parent place PHD' do
      it 'set place type to OD even' do
        place_phd = create(:place)
        place  = create(:place, parent: place_phd)
        expect(place.is_kind_of_od?).to be true
      end
    end

    context 'with parent place OD' do
      it 'set place type to HC even' do
        place_phd = create(:place)
        place_od  = create(:place, parent: place_phd)
        place  = create(:place, parent: place_od)
        expect(place.is_kind_of_hc?).to be true
      end
    end

  end
end
