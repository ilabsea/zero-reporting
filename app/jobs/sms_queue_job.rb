class SmsQueueJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    sms = Sms::Message.from_hash(options)
    Sms::Nuntium.instance.send(sms)
  end
end
