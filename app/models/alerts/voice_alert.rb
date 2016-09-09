module Alerts
  class VoiceAlert
    def initialize place, setting
      @place = place
      @setting = setting
    end

    def enabled?
      @setting && @setting.voice_enabled? && @setting.has_week? && @setting.has_recipient?(HC.kind)
    end

    def message_template
      raise 'voice has no message template'
    end

    def variables
      {
        channel_id: @setting.templates[Alert::TYPES[:voice]].channel_id,
        call_flow_id: @setting.templates[Alert::TYPES[:voice]].call_flow_id,
        not_before: "#{Date.today.strftime('%Y-%m-%d')} #{@setting.templates[Alert::TYPES[:voice]].call_time}:00"
      }
    end

    def recipients
      @recipients ||= @place.users.pluck(:phone).reject(&:empty?)
    end

    def has_recipients?
      !recipients.empty?
    end

    def type
      SmsType.voice
    end
  end
end
