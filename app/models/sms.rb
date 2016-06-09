require 'nuntium'

class Sms
  attr_accessor :nuntium

  def self.instance
    @@instance ||= Sms.new
    @@instance
  end

  def send options
    nuntium.send_ao(options)
  end

  def nuntium
    @nuntium ||= Nuntium.new(ENV['NUNTIUM_HOST'], ENV['NUNTIUM_ACCOUNT'], ENV['NUNTIUM_APP'], ENV['NUNTIUM_APP_PWD'])
  end

  class Options
    def initialize message, tel
      @message = message
      @tel = tel
    end

    def to_nuntium_params
      suggested_channel = Channel.suggested(@tel)
      raise Errors::RecordNotFoundException.new('Channel: there is no active channel available') if suggested_channel.nil?

      {
        from: ENV['APP_NAME'],
        to: "sms://#{@tel.with_country_code}",
        body: @message,
        suggested_channel: suggested_channel.name
      }
    end
  end

end
