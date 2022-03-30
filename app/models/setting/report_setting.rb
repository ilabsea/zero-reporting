class Setting::ReportSetting
  attr_reader :enables, :x_week, :recipient_types

  REPORTER_VARIABLES = %w(place_name last_reported x_week)
  SUPERVISOR_VARIABLES = %w(place_name x_week)

  def initialize options = { recipient_types: [] }
    @days = options[:days] || []
    @enables = options[:enables] || []
    @x_week = options[:x_week].to_i || 0
    @recipient_types = options[:recipient_types].reject(&:empty?) || []
  end

  def templates
    @templates || {}
  end

  def templates=(templates)
    @templates = {}

    templates.each do |k, v|
      # k can be sms, verboice, and telegram
      @templates[k] = "Setting::#{k.titlecase}TemplateSetting".constantize.new(v) if Alert::TYPES.keys.include?(k.to_sym)
    end
  end

  def has_day? wday
    @days.include?(wday.to_s)
  end

  def has_enabled?
    @enables.size > 0
  end

  def voice_enabled?
    @enables.include?(Alert::TYPES[:voice])
  end

  def sms_enabled?
    @enables.include?(Alert::TYPES[:sms])
  end

  def telegram_enabled?
    @enables.include?(Alert::TYPES[:telegram])
  end

  def has_week?
    @x_week > 0
  end

  def has_recipient? place_type
    recipient_types.include? place_type
  end

end
