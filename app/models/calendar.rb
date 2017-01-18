class Calendar
  # start_day format: :sunday, :monday, .., :saturday
  def self.beginning_date_of_week date, start_day = Calendar::Week::DEFAULT_START_DAY
    date.beginning_of_week(start_day = start_day)
  end

  def self.week date
    year = Year.new(date.year)
    diff_days = (beginning_date_of_week(date) - beginning_date_of_week(year.beginning_date)).to_i + 1
    week_number = diff_days / 7
    remaining_week = (diff_days) % 7 > 0 ? 1 : 0
    year.week(week_number + remaining_week)
  end

  def self.weekdays
    { '3' => 'Wed', '4' => 'Thu', '5' => 'Fri', '6' => 'Sat', '0' => 'Sun', '1' => 'Mon', '2' => 'Tue' }
  end
end
