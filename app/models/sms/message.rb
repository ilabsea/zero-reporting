module Sms
  class Message
    attr_reader :receivers, :body

    def initialize receivers = [], body = nil
      @receivers = receivers
      @body = body
    end

    def to_hash
      {receivers: @receivers, body: @body}
    end

    def self.from_hash options
      Sms::Message.new options[:receivers], options[:body]
    end

    def to_nuntium_params
      raise StandardError, "Missing receiver" unless @receivers.present?

      message_options = []

      @receivers.each do |phone|
        tel = Tel.new(phone)
        suggested_channel = Channel.suggested(tel)
        message_options.push({
          from: ENV['APP_NAME'],
          to: "sms://#{tel.with_country_code}",
          body: @body,
          suggested_channel: suggested_channel.name
        }) if suggested_channel
      end

      message_options
    end
  end
end
