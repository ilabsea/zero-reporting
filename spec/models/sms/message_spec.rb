require 'rails_helper'

RSpec.describe Sms::Message, type: :model do
  let(:tel) { Tel.new('010123456') }
  let(:channel) { build(:channel, name: 'Channel1') }

  describe "#from_hash" do
    let(:options) { { to: '1000', body: 'Testing', suggested_channel: channel } }

    it "get message from hash" do
      message = Sms::Message.from_hash(options)

      expect(message.to).to eq('1000')
      expect(message.body).to eq('Testing')
      expect(message.suggested_channel).to a_kind_of(Channel)
    end
  end

  describe "#to_hash" do
    let(:message) { Sms::Message.new( '1000', 'Testing', channel, nil) }

    it "get hash from message object" do
      options = message.to_hash

      expect(options[:to]).to eq('1000')
      expect(options[:body]).to eq('Testing')
      expect(options[:suggested_channel]).to eq(channel)
    end
  end

  describe "#to_nuntium_params" do
    context "raise exception when there is no receiver" do
      let(:sms) { Sms::Message.new '', 'Testing', channel, nil }

      it { expect { sms.to_nuntium_params }.to raise_error(StandardError) }
    end

    context "get nuntium parameters" do
      let(:sms) { Sms::Message.new '010123456', 'Testing', channel, nil }

      it {
        expect(sms.to_nuntium_params).to eq({
          from: ENV['APP_NAME'],
          to: "sms://85510123456",
          body: 'Testing',
          suggested_channel: 'Channel1'
        })
      }
    end
  end
end
