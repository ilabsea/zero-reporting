class Calendar::Week
  DELEMETER = "-"
  DEFAULT_FORMAT = "ww-yyyy"
  STARTING_DAY = :wednesday

  attr_reader :year, :week_number

  def initialize year, week_number
    @year = year
    @week_number = week_number
  end

  def from_date
    Calendar.beginning_date_of_week(@year.beginning_date + ((@week_number - 1) * 7).days)
  end

  def to_date
    from_date + 6.days
  end

  def display format = DEFAULT_FORMAT
    output = []

    format.split(DELEMETER).each do |abbr|
      output.push "w#{@week_number}" if abbr == 'ww'
      output.push "#{@year.number}" if abbr == 'yyyy'
    end

    output.join("-")
  end

  # week_year format: w1-yyyy
  def self.parse week_year
    values = week_year.downcase.delete('w').split(DELEMETER)
    Calendar::Year.new(values[1].to_i).week(values[0].to_i)
  end

end
