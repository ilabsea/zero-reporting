class Sms::Message
  attr_reader :receiver, :body, :suggested_channel, :type

  def initialize receiver, body, suggested_channel, type
    @receiver = receiver
    @body = body
    @suggested_channel = suggested_channel
    @type = type
  end

  def to_hash
    { receiver: @receiver, body: @body, suggested_channel: @suggested_channel, type: @type }
  end

  def self.from_hash options
    Sms::Message.new options[:receiver], options[:body], options[:suggested_channel], options[:type]
  end

  def to_nuntium_params
    raise StandardError, "Missing receiver" unless @receiver.present?
    raise Nuntium::Exception.new('Unknown channel exception') if @suggested_channel.nil? 

    {
      from: ENV['APP_NAME'],
      to: "sms://#{Tel.new(receiver).with_country_code}",
      body: @body,
      suggested_channel: @suggested_channel.name
    }
  end

end
