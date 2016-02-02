# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  password   :string(255)
#  setup_flow :string(255)
#  is_enable  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_channels_on_user_id  (user_id)
#

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
