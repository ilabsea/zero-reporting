require 'rails_helper'

RSpec.describe ChannelNuntium, type: :model do
  let(:local_channel) {create(:channel, name: "local-channel", password: "password", ticket_code: "password", setup_flow: Channel::SETUP_FLOW_BASIC)}
  let(:national_channel) {create(:channel, name: "national-channel", password: "password", setup_flow: Channel::SETUP_FLOW_GLOBAL)}

  describe "#create" do
    context "local gateway" do
      before{
        @channel_nuntium = ChannelNuntium.new(local_channel)
        allow(@channel_nuntium).to receive(:register_nuntium_channel).and_return(true)
      }
      it "return true" do
        expect(@channel_nuntium.create).to eq(true)
      end
    end
    context "national channel" do
      before{
        @channel_nuntium = ChannelNuntium.new(national_channel)
      }
      it "return true" do
        expect(@channel_nuntium.create).to eq(true)
      end
    end
  end

  describe "#delete" do
    context "local gateway" do
      before{
        @channel_nuntium = ChannelNuntium.new(local_channel)
        @channel_nuntium.create
        allow(local_channel).to receive(:destroy!).and_return(true)
        allow(@channel_nuntium).to receive(:delete_nuntium_channel).and_return(true)
      }
      it "return true" do
        expect(@channel_nuntium.delete).to eq(true)
      end
    end
    context "national gateway" do
      before{
        @channel_nuntium = ChannelNuntium.new(national_channel)
        allow(national_channel).to receive(:destroy).and_return(false)
      }
      it "return false" do
        expect(@channel_nuntium.delete).to eq(false)
      end
    end
  end
end
