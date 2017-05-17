class Setting::MessageTemplateSetting
  attr_reader :report_confirmation

  VARIABLES = %w(week_year reported_cases)

  def initialize options = { }
    @report_confirmation = options[:report_confirmation]
  end

end
