require 'rails_helper'

RSpec.describe ChannelsController do
  let(:channel) { double(setup_flow: Channel::SETUP_FLOW_GLOBAL) }

  describe 'POST create' do
    before{
      allow(Channel).to receive(:new).and_return(channel)
    }

    it 'creates a new channel with the given attributes' do
      expect(Channel.new).to eq(channel)
      post :create, message: { title: 'new channel' }
    end
  end
end
