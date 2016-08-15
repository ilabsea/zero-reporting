require 'rails_helper'

RSpec.describe Sms::Nuntium, type: :model do
  let(:nuntium_server) { Sms::Nuntium.instance }

  describe "#nuntium" do
    it "returns nuntium instance" do
      expect(nuntium_server.nuntium).to be_an_instance_of(Nuntium)
    end
  end

  describe "#send" do
    let(:sms) { Sms::Message.new ['010123456'], 'Testing', build(:sms_type, name: :alert) }

    before(:each) do
      @nuntium = double("Nuntium")

      allow(sms).to receive(:to_nuntium_params).and_return([{}])
      allow(nuntium_server).to receive(:nuntium).and_return(@nuntium)
    end

    it "should write alert log and send sms to nuntium" do
      expect(@nuntium).to receive(:send_ao).with([{}]).once

      nuntium_server.send(sms)

      expect(SmsLog.count).to eq(1)
    end
  end
end
