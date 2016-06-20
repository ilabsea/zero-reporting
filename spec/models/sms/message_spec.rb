require 'rails_helper'

RSpec.describe Sms::Message, type: :model do
  let(:tel) { Tel.new('010123456') }
  let(:channel) { build(:channel, name: 'Channel1') }

  describe "#from_hash" do
    let(:options) { {receivers: ['1000'], body: 'Testing'} }

    it "get message from hash" do
      message = Sms::Message.from_hash(options)

      expect(message.receivers.count).to eq(1)
      expect(message.receivers.first).to eq('1000')
      expect(message.body).to eq('Testing')
    end
  end

  describe "#to_hash" do
    let(:message) { Sms::Message.new(['1000'], 'Testing') }

    it "get hash from message object" do
      options = message.to_hash

      expect(options[:receivers].count).to eq(1)
      expect(options[:receivers][0]).to eq('1000')
      expect(options[:body]).to eq('Testing')
    end
  end

  describe "#to_nuntium_params" do
    context "raise exception when there is no receiver" do
      let(:sms) { Sms::Message.new [], 'Testing' }

      it { expect { sms.to_nuntium_params }.to raise_error(StandardError) }
    end

    context "get nuntium parameters" do
      let(:sms) { Sms::Message.new ['010123456'], 'Testing' }

      before(:each) do
        allow(Tel).to receive(:new).and_return(tel)
        allow(Channel).to receive(:suggested).with(tel).and_return(channel)
      end

      it {
        expect(sms.to_nuntium_params).to eq([{
          from: ENV['APP_NAME'],
          to: "sms://85510123456",
          body: 'Testing',
          suggested_channel: 'Channel1'
        }])
      }
    end
  end
end
