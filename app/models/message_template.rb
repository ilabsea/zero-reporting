class MessageTemplate
  def self.instance
    @@instance ||= self.new
  end

  def set_source!(string)
    @source = string
    self
  end

  def interpolate values
    @source.gsub /\{[^\}\}]*\}\}/ do |matched|
      key = matched[2..-3]
      values[key.to_sym] || matched
    end
  end

end
