module Strategies
  module Thresholds
    class CaseBaseStrategy < ThresholdStrategy
      def baseline_of variable, place, week
        Threshold.new :case_base, variable, place, week, variable.threshold_value
      end
    end
  end
end
