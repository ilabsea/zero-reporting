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
#  auditable                    :boolean          default(TRUE)
#
# Indexes
#
#  index_places_on_ancestry  (ancestry)
#

require 'rails_helper'

RSpec.describe Place, type: :model do

  let(:today) { Date.new(2016, 9, 14) }

  before(:each) do
    allow(Date).to receive(:today).and_return(today)
    allow(Calendar).to receive(:beginning_date_of_week).with(today).and_return(today)
  end

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

  describe 'Audit missing report' do
    let!(:hc1) { create(:hc) }
    let!(:hc2) { create(:hc) }
    let!(:hc3) { create(:hc) }
    let!(:user_hc1) { create(:user, place: hc1) }
    let!(:user_hc2) { create(:user, place: hc2) }

    before(:each) do
      create(:report, called_at: today - 13.days, user: user_hc1)
      create(:report, called_at: today - 15.days, user: user_hc2)
    end

    context 'in 1 weeks' do
      it { expect(Place.missing_report_since(Date.new(2016, 9, 7))).to eq [hc1, hc2, hc3] }
    end

    context 'in 2 weeks' do
      it { expect(Place.missing_report_since(Date.new(2016, 8, 31))).to eq [hc2, hc3] }
    end

    context 'in 3 weeks' do
      it { expect(Place.missing_report_since(Date.new(2016, 8, 24))).to eq [hc3] }
    end

  end
end
