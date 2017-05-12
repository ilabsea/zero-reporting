class Setting::MessageTemplateSetting
  attr_reader :report_confirmation

  VARIABLES = %w(report_cases)

  def initialize options = { }
    @report_confirmation = options[:report_confirmation]
  end

end
