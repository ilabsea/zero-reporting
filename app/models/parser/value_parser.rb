module Parser
  class ValueParser

    def initialize(value)
      @value = value
    end

    def parse
      return 0 if @value.nil?

      @value.gsub(/\A([*+0]*)(\d+)\z/) do
        return $2.to_i
      end

      return 0
    end
  end
end
