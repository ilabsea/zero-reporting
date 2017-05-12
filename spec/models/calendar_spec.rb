require 'rails_helper'

RSpec.describe Calendar, type: :model do

  describe "Start date of year by selecting wednesday is the beginning of week" do
    it { expect(Calendar.beginning_date_of_week(Date.new(2015, 1, 1))).to eq(Date.new(2014, 12, 31)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2016, 1, 1))).to eq(Date.new(2015, 12, 30)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2017, 1, 1))).to eq(Date.new(2016, 12, 28)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2018, 1, 1))).to eq(Date.new(2017, 12, 27)) }
  end

  describe "Get week number of specific date" do
    it { expect(Calendar.week(Date.new(2016, 2, 4)).week_number).to eq(6) }
  end

  describe "#week" do

    it {
      week = Calendar.week(Date.new(2008, 1, 1))
      expect(week.week_number).to eq(1)
      expect(week.year.number).to eq(2008)
    }

    it {
      week = Calendar.week(Date.new(2008, 12, 25))
      expect(week.week_number).to eq(1)
      expect(week.year.number).to eq(2009)
    }

    it {
      week = Calendar.week(Date.new(2012, 12, 25))
      expect(week.week_number).to eq(52)
      expect(week.year.number).to eq(2012)
    }

    it {
      week = Calendar.week(Date.new(2012, 12, 26))
      expect(week.week_number).to eq(53)
      expect(week.year.number).to eq(2012)
    }
    #
    it {
      week = Calendar.week(Date.new(2013, 1, 1))
      expect(week.week_number).to eq(53)
      expect(week.year.number).to eq(2012)
    }

    it {
      week = Calendar.week(Date.new(2016, 12, 30))
      expect(week.week_number).to eq(53)
      expect(week.year.number).to eq(2016)
    }

    it {
      week = Calendar.week(Date.new(2017, 1, 3))
      expect(week.week_number).to eq(53)
      expect(week.year.number).to eq(2016)
    }

    it {
      week = Calendar.week(Date.new(2017, 1, 4))
      expect(week.week_number).to eq(1)
      expect(week.year.number).to eq(2017)
    }

    it {
      week = Calendar.week(Date.new(2017, 5, 17))
      expect(week.week_number).to eq(20)
      expect(week.year.number).to eq(2017)
    }
    #
    it {
      week = Calendar.week(Date.new(2017, 12, 31))
      expect(week.week_number).to eq(52)
      expect(week.year.number).to eq(2017)
    }


    it {
      week = Calendar.week(Date.new(2018, 1, 2))
      expect(week.week_number).to eq(52)
      expect(week.year.number).to eq(2017)
    }

    it {
      week = Calendar.week(Date.new(2018, 1, 3))
      expect(week.week_number).to eq(1)
      expect(week.year.number).to eq(2018)
    }

  end

end
