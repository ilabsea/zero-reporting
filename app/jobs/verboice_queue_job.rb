class VerboiceQueueJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    call = Call.from_hash(options)
    Service::Verboice.connect(Setting).call(call)
  end
end
