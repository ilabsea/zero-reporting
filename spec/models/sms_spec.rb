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
end
