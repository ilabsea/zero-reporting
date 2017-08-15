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
      @recipients ||= @place.users.map { |user|
        user.phone if user.sms_alertable?
      }.compact
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      LogType.reminder
    end
  end
end
