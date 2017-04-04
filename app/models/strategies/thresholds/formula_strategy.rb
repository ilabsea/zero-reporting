module Strategies
  module Thresholds
    class FormulaStrategy < ThresholdStrategy
      def baseline_of variable, place, week
        value = variable.threshold_by_place_and_week(place, week)
        Threshold.new :formula, variable, place, week, value
      end
    end
  end
end
