module Alerts
  class PlaceAlert
    def initialize place, setting
      @place = place
      @setting = setting
    end

    def enabled?
      @setting && @setting.sms_enabled? && @setting.has_week?
    end

    def message_template; end

    def recipients
      @recipients ||= @place.users.pluck(:phone).reject(&:empty?)
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      SmsType.reminder
    end
  end
end
