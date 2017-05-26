class Calendar
  # start_day format: :sunday, :monday, .., :saturday
  def self.beginning_date_of_week date, start_day = Calendar::Week::DEFAULT_START_DAY
    date.beginning_of_week(start_day = start_day)
  end

  def self.week date
    year = Year.new(date.year)
    first_week_of_year = year.week(1)

    beginning_date_of_year = first_week_of_year.from_date

    diff_week = (date - beginning_date_of_year).to_i / 7

    diff_week < 0 ? first_week_of_year.previous(-diff_week) : first_week_of_year.next(diff_week)
  end

  def self.weekdays
    {
      '3' => { short_name: 'Wed', code: :wednesday, full_name: 'Wednesday' },
      '4' => { short_name: 'Thu', code: :thursday, full_name: 'Thursday' },
      '5' => { short_name: 'Fri', code: :friday, full_name: 'Friday' },
      '6' => { short_name: 'Sat', code: :saturday, full_name: 'Saturday' },
      '0' => { short_name: 'Sun', code: :sunday, full_name: 'Sunday' },
      '1' => { short_name: 'Mon', code: :monday, full_name: 'Monday' },
      '2' => { short_name: 'Tue', code: :tuesday, full_name: 'Tuesday' }
    }
  end

end
