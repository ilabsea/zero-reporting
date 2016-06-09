require 'rails_helper'

RSpec.describe SmsSimulation, type: :model do
  let(:message) { 'Testing' }
  let(:channel) { build(:channel, name: 'Channel1') }


  let(:sms_simulation) { SmsSimulation.new(message) }

  describe "#broadcast_to" do
    before(:each) do
      allow(Channel).to receive(:suggested).and_return(channel)
      allow_any_instance_of(Sms::Options).to receive(:to_nuntium_params).and_return({})
    end

    it "notify sms job to every users" do
      users = [build(:user)]

      allow(SmsJob).to receive(:set).with(wait: ENV['DELAY_DELIVER_IN_MINUTES'].to_i).and_return(SmsJob)
      allow(SmsJob).to receive(:perform_later).with({}).once

      sms_simulation.simulate_to users
    end
  end
end
