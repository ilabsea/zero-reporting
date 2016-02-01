require 'rails_helper'

RSpec.describe Channel, type: :model do
    context "with valid params" do
      it "return true" do
        channel = Channel.new name: 'channel', password: 'password', ticket_code: 'channel', setup_flow: Channel::SETUP_FLOW_BASIC
        expect(channel.valid?).to be_truthy
      end
    end
    context "with invalid params" do
      it "return false" do
        channel = Channel.new name: 'channel', password: 'password', setup_flow: Channel::SETUP_FLOW_BASIC
        expect(channel.valid?).to be_falsey
      end
    end
    context "when the channel is not existed yet" do
      it "return true" do
        channel = Channel.new name: 'smart', password: 'password', setup_flow: Channel::SETUP_FLOW_GLOBAL
        expect(channel.valid?).to be_truthy
      end
    end
    context "when the channel is existed already" do
      let(:user) {create(:user)}
      it "return false" do
        smart = Channel.create name: 'smart', setup_flow: Channel::SETUP_FLOW_GLOBAL, user_id: user.id
        channel = Channel.new name: 'smart', setup_flow: Channel::SETUP_FLOW_GLOBAL, user_id: user.id
        expect(channel.valid?).to be_falsey
      end
    end

end
