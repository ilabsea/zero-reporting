class SmsBroadcast
  def initialize message
    @message = message
  end

  def broadcast_to users
    return if users.empty?

    raise Nuntium::Exception.new('There is no channel available, please configure channel for sending out message.') unless Channel.has_active?

    alert = Alerts::BroadcastAlert.new(users, @message)
    context = Contexts::SmsAlertContext.new(alert)
    context.process
  end
end
