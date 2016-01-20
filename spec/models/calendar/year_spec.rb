require 'rails_helper'

RSpec.describe Calendar::Year, type: :model do

  describe "Get near_by year" do
    it { expect(Calendar::Year.new(2016).near_by(2).length).to eq(5) }
    it { expect(Calendar::Year.new(2016).near_by(2).first).to eq(2014) }
    it { expect(Calendar::Year.new(2016).near_by(2).last).to eq(2018) }
  end

  describe "Total weeks of year" do
    it { expect(Calendar::Year.new(2016).available_weeks.length).to eq(52) }
    it { expect(Calendar::Year.new(2018).available_weeks.length).to eq(53) }
  end

  describe "Available weeks of year" do
    it { expect(Calendar::Year.new(2016).available_weeks.length).to eq(52) }
    it { expect(Calendar::Year.new(2016).available_weeks.first).to eq("w1-2016") }
    it { expect(Calendar::Year.new(2016).available_weeks.last).to eq("w52-2016") }

    it { expect(Calendar::Year.new(2018).available_weeks.length).to eq(53) }
    it { expect(Calendar::Year.new(2018).available_weeks.first).to eq("w1-2018") }
    it { expect(Calendar::Year.new(2018).available_weeks.last).to eq("w53-2018") }
  end

  describe "Week number" do
    it { expect(Calendar::Year.new(2016).week(0)).to eq(nil) }
    it { expect(Calendar::Year.new(2016).week(53)).to eq(nil) }

    it { expect(Calendar::Year.new(2016).week(1)).to be_a(Calendar::Week) }

    it { expect(Calendar::Year.new(2018).week(53)).to be_a(Calendar::Week) }
  end

end
