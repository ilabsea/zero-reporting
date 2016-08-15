class SmsBroadcast
  def initialize message
    @message = message
  end

  def broadcast_to users
    return if users.empty?

    raise Nuntium::Exception.new('There is no channel available, please configure channel for sending out message.') unless Channel.has_active?

    receivers = users.map { |user| user.phone if user.phone.present? }.compact
    sms = Sms::Message.new(receivers, @message, SmsType.broadcast)
    SmsQueueJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(sms.to_hash)
  end
end
