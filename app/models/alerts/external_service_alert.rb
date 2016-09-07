module Alerts
  class ExternalServiceAlert
    def initialize(setting, caller_phone, call_log_id)
      @setting = setting
      @caller_phone = caller_phone
      @call_log_id = call_log_id
    end

    def enabled?
      @setting.enabled? && !recipients.empty?
    end

    def message_template
      @setting.message_template
    end
    
    def recipients
      @setting.recipients
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      SmsType.verboice
    end

    def variables
      {
        caller_phone: @caller_phone,
        call_log_id: @call_log_id
      }
    end
  end
end
