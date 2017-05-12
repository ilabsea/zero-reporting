class Calendar::Year
  attr_accessor :number
  EXCEPTIONAL_YEAR = ENV['EXCEPTIONAL_YEAR'].split(",").map(&:strip)
  LEAP_YEAR = ENV['LEAP_YEAR'].split(",").map(&:strip)

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
    cam_ewarn_beginning_date = Calendar.beginning_date_of_week beginning_date
    ((end_date - cam_ewarn_beginning_date) + 1).to_i / 7
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def beginning_date
    Date.new(number, 1, 1).tuesday? ? Date.new(number, 1, 2) : Date.new(number, 1, 1)
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def end_date
    Date.new((number + 1), 1, 1).tuesday? ? Date.new((number + 1), 1, 1) : Date.new(number, 12, 31)
  end

  def previous x = 1
    year = clone
    year.number -= x
    year
  end

  def clone
    Calendar::Year.new(number)
  end

  def number_of_days_in_first_week
    first_date = Date.new(number, 1, 1)
    day = Calendar.beginning_date_of_week(first_date, Calendar.days[ENV['WKST']]).day

    if first_date.wday == ENV['WKST'].to_i
      return 7
    elsif first_date.wday < ENV['WKST'].to_i || first_date.wday == 0 || first_date.wday == 6
      return 7-(31-day)-1
    else
      return 7-(first_date.wday - ENV['WKST'].to_i)
    end
  end

  def exceptional_year?
    EXCEPTIONAL_YEAR.include? "#{self.number}"
  end

  def leap_year?
    LEAP_YEAR.include? "#{self.number}"
  end

end
