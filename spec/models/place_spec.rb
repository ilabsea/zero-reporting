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
      let(:place) { create(:phd) }
      it 'set place type to PHD' do
        expect(place.phd?).to be true
      end
    end

    context 'with parent place PHD' do
      it 'set place type to OD even' do
        phd = create(:phd)
        place  = create(:od, parent: phd)
        expect(place.od?).to be true
      end
    end

    context 'with parent place OD' do
      it 'set place type to HC even' do
        phd = create(:phd)
        od  = create(:od, parent: phd)
        place  = create(:hc, parent: od)
        expect(place.hc?).to be true
      end
    end

  end
end
