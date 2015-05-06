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
