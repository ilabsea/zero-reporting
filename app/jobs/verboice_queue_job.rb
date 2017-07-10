class VerboiceQueueJob < ActiveJob::Base
  queue_as ENV['DEFAULT_QUEUE_NAME']

  def perform(options)
    call = Call.from_hash(options)
    Service::Verboice.connect(Setting).call(call)
  end
end
