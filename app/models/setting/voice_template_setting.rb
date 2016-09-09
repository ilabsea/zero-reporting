class Setting::VoiceTemplateSetting
  attr_reader :channel_id, :call_flow_id, :call_time

  def initialize options = {}
    @channel_id = options[:channel_id] || -1
    @call_flow_id = options[:call_flow_id] || -1
    @call_time = options[:call_time]
  end
end
