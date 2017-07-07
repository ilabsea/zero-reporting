class SmsQueueJob < ActiveJob::Base
  queue_as ENV['DEFAULT_QUEUE_NAME']

  def perform(options)
    sms = Sms::Message.from_hash(options)
    Sms::Nuntium.instance.send(sms)
  end
end
