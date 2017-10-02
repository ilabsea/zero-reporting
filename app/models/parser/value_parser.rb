module Parser
  class ValueParser

    def initialize(value)
      @value = value
    end

    def parse
      value = '0'
      @value.gsub(/\A([*+0]*)(\d+)\z/) do
        return $2.to_i
      end
      return value.to_i
    end
  end
end
