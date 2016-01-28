require 'rails_helper'

RSpec.describe ChannelNuntium, type: :model do
  let(:channel) {create(:channel, name: "local-channel", password: "password", ticket_code: "password", setup_flow: Channel::SETUP_FLOW_BASIC)}
  before(:each) do
    @channel_nuntium = ChannelNuntium.new(channel)
    @channel_nuntium.create
  end
  describe "#delete" do
    context "local gateway" do
      it{ expect(@channel_nuntium.delete).to be_true}
    end
    # context "national gateway" do
    #   it{ expect(@channel_nuntium.delete).to be_false}
    # end
  end
end
