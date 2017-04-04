class ThresholdContext
  attr_reader :strategy

  def initialize strategy
    @strategy = strategy
  end

  def baseline_of variable, place, week
    threshold = @strategy.baseline_of variable, place, week
    yield threshold if block_given?
  end
end
