class Calendar::Week
  DELEMETER = "-"
  DEFAULT_FORMAT = "ww-yyyy"
  DEFAULT_START_DAY = :wednesday

  DISPLAY_SHORT_MODE = 1
  DISPLAY_NORMAL_MODE = 2
  DISPLAY_ADVANCED_MODE = 3

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

  # First priority is display format(short, normal, long), then format(ww-yyyy or yyyy-ww)
  def display display_mode = DISPLAY_NORMAL_MODE, format = DEFAULT_FORMAT
    output = []

    format.split(DELEMETER).each do |abbr|
      output.push "w#{@week_number}" if abbr == 'ww'
      output.push "#{@year.number}" if abbr == 'yyyy' && [DISPLAY_NORMAL_MODE].include?(display_mode)
    end

    period = "#{from_date.strftime('%d.%m.%Y')} - #{to_date.strftime('%d.%m.%Y')}" if display_mode == DISPLAY_ADVANCED_MODE

    period ? output.join("-") + ' ' + period : output.join("-")
  end

  # week_year format: w1-yyyy
  def self.parse week_year
    values = week_year.downcase.delete('w').split(DELEMETER)
    Calendar::Year.new(values[1].to_i).week(values[0].to_i)
  end

end
