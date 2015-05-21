class Tel
  PREFIXES = ["+8550", "8550", "+855", "855", "0"]
  AREA_CODE_LENGTH = 2

  def initialize number
    @number = number
  end

  def without_prefix
    result = @number

    PREFIXES.each do |prefix|
      prefix_number = @number[0...prefix.length]
      if prefix == prefix_number
        result = @number[prefix.length..-1]
        break
      end
    end
    
    result
  end

  def area_code
    area_code = nil

    PREFIXES.each do |prefix|
      prefix_number = @number[0...prefix.length]
      if prefix == prefix_number
        area_code = @number[prefix.length...(prefix.length + AREA_CODE_LENGTH)]
        break
      end
    end
    
    area_code
  end

  def operator
    op = Operator.get(area_code: area_code)
    op.nil? ? Operator.other : op
  end

end