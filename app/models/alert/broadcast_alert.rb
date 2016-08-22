module Alert
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
      @recipients ||= @users.map { |user| user.phone if user.phone.present? }.compact
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      SmsType.broadcast
    end

    def variables
      {}
    end
  end
end
