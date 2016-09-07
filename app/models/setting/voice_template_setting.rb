class Setting::VoiceTemplateSetting
  attr_reader :channel_id, :call_flow_id

  def initialize options = {}
    @channel_id = options[:channel_id] || -1
    @call_flow_id = options[:call_flow_id] || -1
  end
end
