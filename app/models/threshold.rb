class Threshold
  attr_reader :method, :variable, :place, :week, :value

  def initialize method, variable, place, week, value
    @method = method
    @variable = variable
    @place = place
    @week = week
    @value = value
  end
end
