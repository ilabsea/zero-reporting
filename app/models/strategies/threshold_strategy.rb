module Strategies
  class ThresholdStrategy
    def self.get method
      "Strategies::Thresholds::#{method.camelize}Strategy".constantize.new rescue StandardError
    end

    def baseline_of variable, place, week
      raise 'have to be implemented on subclass'
    end
  end
end
