class Setting::SmsTemplateSetting
  attr_reader :reporter, :supervisor

  def initialize options = {}
    @reporter = options[:reporter_template] || ''
    @supervisor = options[:supervisor_template] || ''
  end
end
