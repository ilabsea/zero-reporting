class CallStatusJob < ActiveJob::Base
  queue_as ENV['DEFAULT_QUEUE_NAME']

  def perform(call_log_id, status)
    Report.create_from_call_log_with_status(call_log_id, status)
  end
end
