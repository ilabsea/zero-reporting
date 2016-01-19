class Calendar
  DELEMETER = "-"

  def self.available_weeks year
    weeks = []
    Calendar.total_week_of_year(year).times.each do |week_number|
      weeks.push("w#{week_number + 1}-#{year}")
    end
    weeks
  end

  # week_year format: w1-yyyy
  def self.period_from_string week_year
    values = year_week_from_string week_year
    Calendar.period values[:year], values[:week]
  end

  def self.period year, week_number
    start_date_of_week = Calendar.beginning_date_of_week(Calendar.new_year_date(year) + ((week_number - 1) * 7).days)
    end_date_of_week = start_date_of_week + 6.days
    {from: start_date_of_week, to: end_date_of_week}
  end

  def self.beginning_date_of_week date
    date.beginning_of_week(start_day = :wednesday)
  end

  def self.total_week_of_year year
    beginning_date_of_year = Calendar.beginning_date_of_week Calendar.new_year_date(year)
    end_date_of_year = Calendar.end_date_of_year(year)
    ((end_date_of_year - beginning_date_of_year) + 1).to_i / 7
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def self.new_year_date year
    Date.new(year, 1, 1).tuesday? ? Date.new(year, 1, 2) : Date.new(year, 1, 1)
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def self.end_date_of_year year
    Date.new((year + 1), 1, 1).tuesday? ? Date.new((year + 1), 1, 1) : Date.new(year, 12, 31)
  end

  # week_year format: w1-yyyy
  def self.year_week_from_string week_year
    values = week_year.downcase.delete('w').split(Calendar::DELEMETER)
    {year: values[1].to_i, week: values[0].to_i}
  end

end
