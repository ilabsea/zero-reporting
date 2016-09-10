module Adapter
  class VoiceAlertAdapter
    def initialize alert
      @alert = alert
    end

    def process
      return if !@alert.enabled? || !@alert.has_recipients?

      call = Call.new(@alert.recipients, @alert.variables[:call_flow_id], @alert.variables[:channel_id], @alert.type, @alert.variables[:not_before])

      VerboiceQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(call.to_hash)
    end
  end
end
