class Sms::Message
  attr_reader :to, :body, :suggested_channel, :type

  def initialize to, body, suggested_channel, type
    @to = to
    @body = body
    @suggested_channel = suggested_channel
    @type = type
  end

  def to_hash
    { to: @to, body: @body, suggested_channel: @suggested_channel, type: @type }
  end

  def self.from_hash options
    Sms::Message.new options[:to], options[:body], options[:suggested_channel], options[:type]
  end

  def to_nuntium_params
    raise StandardError, "Missing recipient" unless @to.present?
    raise Nuntium::Exception.new('Unknown channel exception') if @suggested_channel.nil? 

    {
      from: ENV['APP_NAME'],
      to: "sms://#{Tel.new(@to).with_country_code}",
      body: @body,
      suggested_channel: @suggested_channel.name
    }
  end

end
