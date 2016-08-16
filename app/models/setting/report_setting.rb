class Setting::ReportSetting
  attr_reader :x_week, :message_template, :recipient_type

  VARIABLES = %w(place_name last_reported x_week)

  def initialize options = {}
    @enabled = options[:enabled].to_i || false
    @x_week = options[:x_week].to_i || 0
    @message_template = options[:message_template] || ''
    @recipient_type = options[:recipient_type].reject(&:empty?) || []
  end

  def enabled?
    @enabled === true || @enabled === 1
  end
end
