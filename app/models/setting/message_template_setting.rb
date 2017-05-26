class Setting::MessageTemplateSetting
  attr_reader :enabled, :report_confirmation

  VARIABLES = %w(week_year reported_cases)

  def initialize options = { }
    @enabled = options[:enabled] || false
    @report_confirmation = options[:report_confirmation]
  end

  def enabled?
    enabled
  end

end
