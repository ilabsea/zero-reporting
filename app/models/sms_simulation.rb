class SmsSimulation
  def initialize message
    @message = message
  end

  def simulate_to users
    users.each do |user|
      if user.phone.present?
        nuntium_params = Sms::Options.new(@message, Tel.new(user.phone)).to_nuntium_params
        SmsJob.set(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).perform_later(nuntium_params)
      end
    end
  end
end
