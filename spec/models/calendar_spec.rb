require 'rails_helper'

RSpec.describe Calendar, type: :model do

  describe "Start date of year by selecting wednesday is the beginning of week" do
    it { expect(Calendar.beginning_date_of_week(Date.new(2015, 1, 1))).to eq(Date.new(2014, 12, 31)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2016, 1, 1))).to eq(Date.new(2015, 12, 30)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2017, 1, 1))).to eq(Date.new(2016, 12, 28)) }
    it { expect(Calendar.beginning_date_of_week(Date.new(2018, 1, 1))).to eq(Date.new(2017, 12, 27)) }
  end

  describe "Get week number of specific date" do
    it { expect(Calendar.week(Date.new(2016, 2, 4)).week_number).to eq(5) }
  end

end
