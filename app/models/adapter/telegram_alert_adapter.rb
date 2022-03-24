module Adapter
  class TelegramAlertAdapter
    attr_reader :alert

    def initialize(alert)
      @alert = alert
    end

    def process
      return unless alert.enabled? && alert.has_recipients?

      users = User.telegrams.where(phone: alert.recipients)
      users.each do |user|
        params = { "user_id": user.id, "message": display_message }

        TelegramQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(params)
      end
    end

    private
      def display_message
        MessageTemplate.instance
                       .set_source!(alert.message_template)
                       .interpolate(alert.variables)
      end
  end
end
