require 'nuntium'

class Sms
  attr_accessor :nuntium

  def self.instance
    @@instance ||= Sms.new
    @@instance
  end

  # from: ej: Feed Alert
  #   to: ej: sms://012888555
  # body: ej: simple text
  def send options
    # options[:country] = ENV['NUNTIUM_PWD_COUNTRY']
    # options[:suggested_channel] = ENV['NUNTIUM_CHANNEL']
    nuntium.send_ao(options)
  end

  def nuntium
    @nuntium ||= Nuntium.new(ENV['NUNTIUM_HOST'], ENV['NUNTIUM_ACCOUNT'], ENV['NUNTIUM_APP'], ENV['NUNTIUM_APP_PWD'])
  end

end
