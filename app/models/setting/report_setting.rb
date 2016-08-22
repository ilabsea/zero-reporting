class Setting::ReportSetting
  attr_reader :x_week, :message_template_reporter, :message_template_supervisor, :recipient_types

  REPORTER_VARIABLES = %w(place_name last_reported x_week)
  SUPERVISOR_VARIABLES = %w(place_name x_week)

  def initialize options = { recipient_types: [] }
    @enabled = options[:enabled ].to_i || false
    @x_week = options[:x_week].to_i || 0
    @message_template_reporter = options[:message_template_reporter] || ''
    @message_template_supervisor = options[:message_template_supervisor] || ''
    @recipient_types = options[:recipient_types].reject(&:empty?) || []
  end

  def enabled?
    @enabled === true || @enabled === 1
  end

  def has_week?
    @x_week > 0
  end

  def has_recipient? place_type
    recipient_types.include? place_type
  end
end
