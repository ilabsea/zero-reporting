class Call
  attr_reader :receivers, :call_flow_id, :channel_id, :type, :not_before

  def initialize receivers, call_flow_id, channel_id, type, not_before
    @receivers = receivers || []
    @call_flow_id = call_flow_id
    @channel_id = channel_id
    @type = type
    @not_before = not_before || Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

  def to_hash
    { receivers: @receivers, call_flow_id: @call_flow_id, channel_id: @channel_id, type: @type, not_before: @not_before }
  end

  def self.from_hash options
    Call.new options[:receivers], options[:call_flow_id], options[:channel_id], options[:type], options[:not_before]
  end

  def to_verboice_calls
    calls = []

    @receivers.each do |address|
      calls.push({
        address: address,
        channel_id: @channel_id,
        call_flow_id: @call_flow_id,
        not_before: @not_before
      })
    end

    calls
  end
end
