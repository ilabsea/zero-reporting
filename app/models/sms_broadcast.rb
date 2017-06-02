class SmsBroadcast
  def initialize message
    @message = message
  end

  def broadcast_to users
    return if users.empty?

    alert = Alerts::BroadcastAlert.new(users, @message)
    adapter = Adapter::SmsAlertAdapter.new(alert)
    adapter.process
  end
end
