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

end
