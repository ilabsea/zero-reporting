require 'rails_helper'

RSpec.describe Calendar, type: :model do

  describe "Start date of year by selecting wednesday is the beginning of week" do
    it { expect(Calendar.beginning_date_of_week(Date.new(2015, 1, 1))).to eq(Date.new(2014, 12, 31)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2016, 1, 1))).to eq(Date.new(2015, 12, 30)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2017, 1, 1))).to eq(Date.new(2016, 12, 28)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2018, 1, 1))).to eq(Date.new(2017, 12, 27)) }
  end

  describe ".period" do
    context "Period of specific week number in year" do
      it { expect(Calendar.period(2015, 1)).to eq({from: Date.new(2014, 12, 31), to: Date.new(2015, 1, 6)}) }
      it { expect(Calendar.period(2015, 4)).to eq({from: Date.new(2015, 1, 21), to: Date.new(2015, 1, 27)}) }
      it { expect(Calendar.period(2016, 1)).to eq({from: Date.new(2015, 12, 30), to: Date.new(2016, 1, 5)}) }
      it { expect(Calendar.period(2016, 4)).to eq({from: Date.new(2016, 1, 20), to: Date.new(2016, 1, 26)}) }
      it { expect(Calendar.period(2017, 1)).to eq({from: Date.new(2016, 12, 28), to: Date.new(2017, 1, 3)}) }
      it { expect(Calendar.period(2017, 4)).to eq({from: Date.new(2017, 1, 18), to: Date.new(2017, 1, 24)}) }
      it { expect(Calendar.period(2018, 1)).to eq({from: Date.new(2017, 12, 27), to: Date.new(2018, 1, 2)}) }
      it { expect(Calendar.period(2018, 4)).to eq({from: Date.new(2018, 1, 17), to: Date.new(2018, 1, 23)}) }
    end

    context "Period from string 'yyyy-w1'" do
      it { expect(Calendar.period_from_string("W1-2015")).to eq({from: Date.new(2014, 12, 31), to: Date.new(2015, 1, 6)}) }
      it { expect(Calendar.period_from_string("w4-2015")).to eq({from: Date.new(2015, 1, 21), to: Date.new(2015, 1, 27)}) }
      it { expect(Calendar.period_from_string("w52-2015")).to eq({from: Date.new(2015, 12, 23), to: Date.new(2015, 12, 29)}) }
      it { expect(Calendar.period_from_string("W1-2016")).to eq({from: Date.new(2015, 12, 30), to: Date.new(2016, 1, 5)}) }
      it { expect(Calendar.period_from_string("w4-2016")).to eq({from: Date.new(2016, 1, 20), to: Date.new(2016, 1, 26)}) }
      it { expect(Calendar.period_from_string("w52-2016")).to eq({from: Date.new(2016, 12, 21), to: Date.new(2016, 12, 27)}) }
      it { expect(Calendar.period_from_string("W1-2017")).to eq({from: Date.new(2016, 12, 28), to: Date.new(2017, 1, 3)}) }
      it { expect(Calendar.period_from_string("w4-2017")).to eq({from: Date.new(2017, 1, 18), to: Date.new(2017, 1, 24)}) }
      it { expect(Calendar.period_from_string("w52-2017")).to eq({from: Date.new(2017, 12, 20), to: Date.new(2017, 12, 26)}) }
      it { expect(Calendar.period_from_string("W1-2018")).to eq({from: Date.new(2017, 12, 27), to: Date.new(2018, 1, 2)}) }
      it { expect(Calendar.period_from_string("w4-2018")).to eq({from: Date.new(2018, 1, 17), to: Date.new(2018, 1, 23)}) }
      it { expect(Calendar.period_from_string("w53-2018")).to eq({from: Date.new(2018, 12, 26), to: Date.new(2019, 1, 1)}) }
      it { expect(Calendar.period_from_string("W1-2019")).to eq({from: Date.new(2019, 1, 2), to: Date.new(2019, 1, 8)}) }
    end
  end

  describe "Available weeks of year" do
    it { expect(Calendar.available_weeks(2016).length).to eq(52) }
    it { expect(Calendar.available_weeks(2016).first).to eq("w1-2016") }
    it { expect(Calendar.available_weeks(2016).last).to eq("w52-2016") }

    it { expect(Calendar.available_weeks(2018).length).to eq(53) }
    it { expect(Calendar.available_weeks(2018).first).to eq("w1-2018") }
    it { expect(Calendar.available_weeks(2018).last).to eq("w53-2018") }
  end

  describe "Year week from string format 'w1-yyyy'" do
    it { expect(Calendar.year_week_from_string("w1-2016")).to eq({year: 2016, week: 1}) }
    it { expect(Calendar.year_week_from_string("w2-2018")).to eq({year: 2018, week: 2}) }
  end

end
