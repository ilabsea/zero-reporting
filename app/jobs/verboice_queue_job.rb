class VerboiceQueueJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    call = Call.from_hash(options)
    Service::Verboice.connect(Setting).bulk_call(call.to_verboice_calls)
  end
end
