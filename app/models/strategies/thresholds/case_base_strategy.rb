module Strategies
  module Thresholds
    class CaseBaseStrategy < ThresholdStrategy
      def baseline_of variable, place, week
        Threshold.new :case_base, variable, place, week, 0
      end
    end
  end
end
