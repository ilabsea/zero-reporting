class MessageTemplate
  def self.instance
    @@instance ||= self.new
    @@instance
  end

  def set_source(string)
    @source = string
    self
  end

  def translate values
    @source.gsub /\{[^\}\}]*\}\}/ do |matched|
      key = matched[2..-3]
      values[key.to_sym] || matched
    end
  end

  def translate_reported_cases reported_cases
    messages = []
    reported_cases.each do |reported_case|
      message = self.translate(reported_case)
      messages << message
    end
    messages
  end
end
