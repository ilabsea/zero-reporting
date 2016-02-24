class Threshold
  def initialize(week, place, variable)
    @week = week
    @place = place
    @variable = variable
  end

  def value
    @variable.threshold_by_place_and_week(@place, @week)
  end
end
