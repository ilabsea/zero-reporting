module Alerts
  class BroadcastAlert
    def initialize(users, message)
      @users = users
      @message = message
    end

    def enabled?
      true
    end

    def message_template
      @message
    end

    def recipients
      @recipients ||= @users.map { |user|
        user.phone if user.sms_alertable?
      }.compact
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      LogType.broadcast
    end

    def variables
      {}
    end
  end
end
