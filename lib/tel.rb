class Tel
  PREFIXES = ["+8550", "8550", "+855", "855", "0", "+0", "+"]
  AREA_CODE_LENGTH = 2

  def initialize number
    @number = number
  end

  def without_prefix
    result = @number

    Tel::PREFIXES.each do |prefix|
      return @number[prefix.length..-1] if @number.start_with?(prefix)
    end
    @number
  end
end