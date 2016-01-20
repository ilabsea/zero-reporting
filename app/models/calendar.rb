class Calendar
  def self.beginning_date_of_week date
    date.beginning_of_week(start_day = Calendar::Week::STARTING_DAY)
  end
end
