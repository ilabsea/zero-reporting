class VerboiceQueueJob < ActiveJob::Base
  queue_as :default

  def perform(addresses, options)
    Service::Verboice.connect(Setting).bulk_call(addresses, options)
  end
end
