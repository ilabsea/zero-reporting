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
    it { expect(Calendar::Year.new(2016).available_weeks.first).to be_a(Calendar::Week) }
    it { expect(Calendar::Year.new(2016).available_weeks.last).to be_a(Calendar::Week) }

    it { expect(Calendar::Year.new(2018).available_weeks.length).to eq(53) }
    it { expect(Calendar::Year.new(2018).available_weeks.first).to be_a(Calendar::Week) }
    it { expect(Calendar::Year.new(2018).available_weeks.last).to be_a(Calendar::Week) }
  end

  describe "Week number" do
    it { expect(Calendar::Year.new(2016).week(0)).to eq(nil) }
    it { expect(Calendar::Year.new(2016).week(53)).to eq(nil) }

    it { expect(Calendar::Year.new(2016).week(1)).to be_a(Calendar::Week) }

    it { expect(Calendar::Year.new(2018).week(53)).to be_a(Calendar::Week) }
  end


  describe "#number_of_days_in_first_week" do
    context "first day of year is on the starting day of week" do
      it {
        expect(Calendar::Year.new(1992).number_of_days_in_first_week).to eq(7)
      }
    end

    context "first day of year is on Sunday, Monday, Tuesday" do
      it {
        expect(Calendar::Year.new(1989).number_of_days_in_first_week).to eq(3)
        expect(Calendar::Year.new(2008).number_of_days_in_first_week).to eq(1)
      }
    end

    context "first day of year is on Thursday or Friday" do
      it {
        expect(Calendar::Year.new(2004).number_of_days_in_first_week).to eq(6)
        expect(Calendar::Year.new(1993).number_of_days_in_first_week).to eq(5)
      }
    end

  end

  describe "#exceptional_year" do
    context "when year is included in expectional years" do
      it { expect(Calendar::Year.new(2016).exceptional_year?).to be true }
    end

    context "when year is not included in exceptional years" do
      it { expect(Calendar::Year.new(2002).exceptional_year?).to be false }
    end
  end

end
