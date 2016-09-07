module Contexts
  class VoiceAlertContext
    def initialize alert
      @alert = alert
    end

    def process
      return if !@alert.enabled? || !@alert.has_recipients?

      VerboiceQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(@alert.recipients, @alert.variables)
    end
  end
end
