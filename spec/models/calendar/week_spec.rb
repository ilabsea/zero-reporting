require 'rails_helper'

RSpec.describe Calendar::Week, type: :model do

  describe "Period of specific week number in year" do
    it { expect(Calendar::Year.new(2015).week(1).from_date).to eq(Date.new(2014, 12, 31)) }
    it { expect(Calendar::Year.new(2015).week(1).to_date).to eq(Date.new(2015, 1, 6)) }

    it { expect(Calendar::Year.new(2015).week(4).from_date).to eq(Date.new(2015, 1, 21)) }
    it { expect(Calendar::Year.new(2015).week(4).to_date).to eq(Date.new(2015, 1, 27)) }

    it { expect(Calendar::Year.new(2015).week(52).from_date).to eq(Date.new(2015, 12, 23)) }
    it { expect(Calendar::Year.new(2015).week(52).to_date).to eq(Date.new(2015, 12, 29)) }

    it { expect(Calendar::Year.new(2016).week(1).from_date).to eq(Date.new(2015, 12, 30)) }
    it { expect(Calendar::Year.new(2016).week(1).to_date).to eq(Date.new(2016, 1, 5)) }

    it { expect(Calendar::Year.new(2016).week(4).from_date).to eq(Date.new(2016, 1, 20)) }
    it { expect(Calendar::Year.new(2016).week(4).to_date).to eq(Date.new(2016, 1, 26)) }

    it { expect(Calendar::Year.new(2016).week(53).from_date).to eq(Date.new(2016, 12, 28)) }
    it { expect(Calendar::Year.new(2016).week(53).to_date).to eq(Date.new(2017, 1, 3)) }

    it { expect(Calendar::Year.new(2017).week(4).from_date).to eq(Date.new(2017, 1, 25)) }
    it { expect(Calendar::Year.new(2017).week(4).to_date).to eq(Date.new(2017, 1, 31)) }

    it { expect(Calendar::Year.new(2018).week(1).from_date).to eq(Date.new(2018, 1, 3)) }
    it { expect(Calendar::Year.new(2018).week(1).to_date).to eq(Date.new(2018, 1, 9)) }

    it { expect(Calendar::Year.new(2018).week(4).from_date).to eq(Date.new(2018, 1, 24)) }
    it { expect(Calendar::Year.new(2018).week(4).to_date).to eq(Date.new(2018, 1, 30)) }
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

  describe 'Get last of' do
    before(:each) do
      now = Time.local(2017, 1, 1, 12, 0, 0)
      Timecop.freeze(now)
    end

    context '2 weeks of today' do
      let(:date) { Date.today }
      let(:week) { Calendar.week(date) }

      it { expect(week.year.number).to eq(2016) }
      it { expect(week.week_number).to eq(53) }

      it { expect(Calendar::Week.last_of(date)[0].year.number).to eq(2016) }
      it { expect(Calendar::Week.last_of(date)[0].week_number).to eq(53) }
    end

    context '2 weeks of specific date' do
      let(:date) { Date.new(2016, 12, 25) }
      let(:week) { Calendar.week(date) }

      it { expect(week.year.number).to eq(2016) }
      it { expect(week.week_number).to eq(52) }

      it { expect(Calendar::Week.last_of(date, 2)[0].year.number).to eq(2016) }
      it { expect(Calendar::Week.last_of(date, 2)[0].week_number).to eq(52) }
      it { expect(Calendar::Week.last_of(date, 2)[1].year.number).to eq(2016) }
      it { expect(Calendar::Week.last_of(date, 2)[1].week_number).to eq(51) }
    end
  end

  describe '#next' do
    context 'unexceptional year' do
      let!(:week) { Calendar::Year.new(2008).week(1) }

      it { expect(week.next(52).year.number).to eq(2009) }
      it { expect(week.next(52).week_number).to eq(1) }
    end

    context 'exceptional year' do
      let!(:week) { Calendar::Year.new(2016).week(1) }

      it { expect(week.next(52).year.number).to eq(2016) }
      it { expect(week.next(52).week_number).to eq(53) }

      it { expect(week.next(53).year.number).to eq(2017) }
      it { expect(week.next(53).week_number).to eq(1) }
    end
  end

end
