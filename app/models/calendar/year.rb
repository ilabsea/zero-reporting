class Calendar::Year
  attr_accessor :number

  def initialize number
    self.number = number
  end

  def week number
    return nil if number == nil || number <= 0 || number > total_weeks

    Calendar::Week.new(self, number)
  end

  def near_by number = 2
    years = []
    ((-number)..(number)).each do |i|
      years.push(self.number + i)
    end
    years
  end

  def available_weeks
    weeks = []
    (1..total_weeks).each do |week_number|
      weeks.push(week(week_number))
    end
    weeks
  end

  def total_weeks
    Setting.exceptional_years.include?(number.to_s) ? 53 : 52
  end

  def beginning_date
    first_date_of_year = Date.new(number, 1, 1)

    start_date_first_week_current_year = Calendar.beginning_date_of_week first_date_of_year

    if Setting.exceptional_years.include?((number - 1).to_s) || (start_date_first_week_current_year + (Setting.wkst + 1).day) < first_date_of_year
      start_date_first_week_current_year += 7
    end

    start_date_first_week_current_year
  end

  def end_date
    beginning_date + ((total_weeks * 7) - 1).day
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def beginning_date_old
    Date.new(number, 1, 1).tuesday? ? Date.new(number, 1, 2) : Date.new(number, 1, 1)
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def end_date_old
    Date.new((number + 1), 1, 1).tuesday? ? Date.new((number + 1), 1, 1) : Date.new(number, 12, 31)
  end

  def previous x = 1
    move(-x)
  end

  def next x = 1
    move(x)
  end

  def number_of_days_in_first_week
    first_date = Date.new(number, 1, 1)
    day = Calendar.beginning_date_of_week(first_date).day

    if first_date.wday == Setting.wkst
      return 7
    elsif first_date.wday < Setting.wkst || first_date.wday == 0 || first_date.wday == 6
      return 7-(31-day)-1
    else
      return 7-(first_date.wday - Setting.wkst)
    end
  end

  def exceptional_year?
    Setting.exceptional_years.include? "#{self.number}"
  end

  private

  # posive x: move next
  # negative x: move previous
  def move x
    year = clone
    year.number = year.number + x
    year
  end

  def clone
    Calendar::Year.new(number)
  end

end
