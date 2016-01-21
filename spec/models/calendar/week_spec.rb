require 'rails_helper'

RSpec.describe Calendar::Week, type: :model do

  describe "Period of specific week number in year" do
    it { expect(Calendar::Year.new(2015).week(1).from_date).to eq(Date.new(2014, 12, 31)) }
    it { expect(Calendar::Year.new(2015).week(1).to_date).to eq(Date.new(2015, 1, 6)) }

    it { expect(Calendar::Year.new(2015).week(4).from_date).to eq(Date.new(2015, 1, 21)) }
    it { expect(Calendar::Year.new(2015).week(4).to_date).to eq(Date.new(2015, 1, 27)) }

    it { expect(Calendar::Year.new(2016).week(1).from_date).to eq(Date.new(2015, 12, 30)) }
    it { expect(Calendar::Year.new(2016).week(1).to_date).to eq(Date.new(2016, 1, 5)) }

    it { expect(Calendar::Year.new(2016).week(4).from_date).to eq(Date.new(2016, 1, 20)) }
    it { expect(Calendar::Year.new(2016).week(4).to_date).to eq(Date.new(2016, 1, 26)) }

    it { expect(Calendar::Year.new(2017).week(1).from_date).to eq(Date.new(2016, 12, 28)) }
    it { expect(Calendar::Year.new(2017).week(1).to_date).to eq(Date.new(2017, 1, 3)) }

    it { expect(Calendar::Year.new(2017).week(4).from_date).to eq(Date.new(2017, 1, 18)) }
    it { expect(Calendar::Year.new(2017).week(4).to_date).to eq(Date.new(2017, 1, 24)) }

    it { expect(Calendar::Year.new(2018).week(1).from_date).to eq(Date.new(2017, 12, 27)) }
    it { expect(Calendar::Year.new(2018).week(1).to_date).to eq(Date.new(2018, 1, 2)) }

    it { expect(Calendar::Year.new(2018).week(4).from_date).to eq(Date.new(2018, 1, 17)) }
    it { expect(Calendar::Year.new(2018).week(4).to_date).to eq(Date.new(2018, 1, 23)) }
  end

  describe "Year week from string format 'w1-yyyy'" do
    it { expect(Calendar::Week.parse("w1-2016").year.number).to eq(2016) }
    it { expect(Calendar::Week.parse("w1-2016").week_number).to eq(1) }

    it { expect(Calendar::Week.parse("w2-2018").year.number).to eq(2018) }
    it { expect(Calendar::Week.parse("w2-2018").week_number).to eq(2) }
  end

  describe "Display of week format" do
    context "Short format" do
      it { expect(Calendar::Year.new(2016).week(1).display(Calendar::Week::DISPLAY_SHORT_MODE)).to eq("w1") }
    end

    context "Normal format" do
      it { expect(Calendar::Year.new(2016).week(1).display).to eq("w1-2016") }
      it { expect(Calendar::Year.new(2016).week(1).display(Calendar::Week::DISPLAY_NORMAL_MODE)).to eq("w1-2016") }
      it { expect(Calendar::Year.new(2016).week(1).display(Calendar::Week::DISPLAY_NORMAL_MODE, "yyyy-ww")).to eq("2016-w1") }
    end

    context "Advanced format" do
      it { expect(Calendar::Year.new(2016).week(1).display(Calendar::Week::DISPLAY_ADVANCED_MODE)).to eq("w1 30.12.2015 - 05.01.2016") }
    end
  end

end
