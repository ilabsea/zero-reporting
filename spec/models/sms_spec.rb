require 'rails_helper'

RSpec.describe Sms, type: :model do
  before :each do
    @sms = double("Sms")
  end
  describe "#nuntium" do
    it "returns nuntium instance" do
      expect(@sms).to receive(:nuntium).and_return(:nuntium)
      @sms.nuntium
    end
  end
  describe "#send" do
    it "send sms to correct user" do
      option = {:from =>"Zero Reporting", :to => "sms://855103456789", :body => "reporting", :suggested_channel => "smart" }
      expect(@sms).to receive(:send).with(option)
      expect(@sms).to receive(:send).with([option])
      @sms.send(option)
      @sms.send([option])
    end
  end

  describe "#options" do
    let!(:tel) { Tel.new('010888999') }
    let!(:sms_options) { Sms::Options.new('Just testing', tel) }
    let!(:channel) { build(:channel, name: 'Testing') }

    it "to nuntium parameters" do
      expect(Channel).to receive(:suggested).with(tel).and_return(channel)
      expect(sms_options.to_nuntium_params).to eq({
        from: ENV['APP_NAME'],
        to: "sms://85510888999",
        body: 'Just testing',
        suggested_channel: 'Testing'
      })
    end
  end
end
