class SmsJob < ActiveJob::Base
  queue_as :default

  def perform(message_options)
    Sms.instance().send(message_options)
    AlertLog.create(message_options)
  end
end
