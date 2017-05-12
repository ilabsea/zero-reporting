class Calendar
  # start_day format: :sunday, :monday, .., :saturday
  def self.beginning_date_of_week date, start_day = Calendar::Week::DEFAULT_START_DAY
    date.beginning_of_week(start_day = start_day)
  end

  def self.week date
    week_number = -1
    current_year = Year.new(date.year)
    year = current_year
    day_of_year = date.yday
    days_in_first_week = year.number_of_days_in_first_week


    if day_of_year <= days_in_first_week

      return Calendar::Week.new(year, 1) if days_in_first_week >= 4
      last_year = Year.new(date.year-1)
      year = last_year
      days_in_first_week_of_last_year = last_year.number_of_days_in_first_week
      if(days_in_first_week_of_last_year >= 4 || last_year.leap_year?)
        week_number = 53
        return Calendar::Week.new(last_year, week_number)
      else
        week_number = 52
      end

    else
      week_number = ((day_of_year - days_in_first_week)/7.0).ceil
    end

    if (( days_in_first_week >= 4 || current_year.leap_year?) && week_number < 53 )
      week_number = week_number + 1
    end

    next_year = Year.new(date.year+1)
    if (week_number >= 53 && next_year.number_of_days_in_first_week >= 4)
      if day_of_year <= days_in_first_week
        return Calendar::Week.new(current_year, 1)
      else
        return Calendar::Week.new(next_year, 1)
      end
    elsif week_number == 53 && !year.exceptional_year?
      return Calendar::Week.new(next_year, 1)
    end

    return Calendar::Week.new(year, week_number)
  end

  def self.weekdays
    { '3' => 'Wed', '4' => 'Thu', '5' => 'Fri', '6' => 'Sat', '0' => 'Sun', '1' => 'Mon', '2' => 'Tue' }
  end

  def self.days
    { '3' => :wednesday, '4' => :thursday, '5' => :friday, '6' => :saturday, '0' => :sunday, '1' => :monday, '2' => :tuesday }
  end

end
