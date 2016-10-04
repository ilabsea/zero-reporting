require 'nuntium'

module Sms
  class Nuntium
    attr_accessor :nuntium

    def self.instance
      @@instance ||= Sms::Nuntium.new
    end

    def send sms
      Log.write_sms sms

      nuntium.send_ao sms.to_nuntium_params
    end

    def nuntium
      @nuntium ||= ::Nuntium.new(ENV['NUNTIUM_HOST'], ENV['NUNTIUM_ACCOUNT'], ENV['NUNTIUM_APP'], ENV['NUNTIUM_APP_PWD'])
    end
  end
end
