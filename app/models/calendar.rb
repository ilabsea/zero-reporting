class Calendar
  # start_day format: :sunday, :monday, .., :saturday
  def self.beginning_date_of_week date, start_day = Calendar::Week::DEFAULT_START_DAY
    date.beginning_of_week(start_day = start_day)
  end

  def self.week_number date, start_day = Calendar::Week::DEFAULT_START_DAY
    year = Year.new(date.year)
    begining_date_of_week = date.beginning_of_week(start_day = start_day)
    week_number = (begining_date_of_week - year.beginning_date).to_i / 7
    remaining_days = (begining_date_of_week - year.beginning_date).to_i % 7 > 0 ? 1 : 0
    year.week(week_number + remaining_days).week_number
  end
end
