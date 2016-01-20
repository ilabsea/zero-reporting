class Calendar::Year
  attr_reader :number

  def initialize number
    @number = number
  end

  def week number
    return nil if number <= 0 or number > total_weeks
    Calendar::Week.new(self, number)
  end

  def near_by number
    years = []
    ((-number)..(number)).each do |i|
      years.push(@number + i)
    end
    years
  end

  def available_weeks
    weeks = []
    (1..total_weeks).each do |week_number|
      weeks.push(week(week_number).display)
    end
    weeks
  end

  def total_weeks
    cam_ewarn_beginning_date = Calendar.beginning_date_of_week beginning_date
    ((end_date - cam_ewarn_beginning_date) + 1).to_i / 7
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def beginning_date
    Date.new(@number, 1, 1).tuesday? ? Date.new(@number, 1, 2) : Date.new(@number, 1, 1)
  end

  # follows CamEwarn calendar weekly report, wednesday is starting day
  def end_date
    Date.new((@number + 1), 1, 1).tuesday? ? Date.new((@number + 1), 1, 1) : Date.new(@number, 12, 31)
  end

end
