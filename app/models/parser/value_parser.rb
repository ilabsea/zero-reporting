module Parser
  class ValueParser

    def initialize(value)
      @value = value
    end

    def parse
      return is_integer? ? @value.to_i : decode_value.to_i
    end

    private
    def decode_value
      value = 0
      @value.gsub(/\A(\D+)(\d+)\z/) do
        value = $2
      end
      return value
    end

    def is_integer?
      @value =~ /\A\d+\z/ ? true : false
    end
  end
end
