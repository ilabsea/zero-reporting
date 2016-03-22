require 'rails_helper'

RSpec.describe ExternalSmsResult, type: :model do
  include ActiveJob::TestHelper
  let!(:smart){create(:channel, name: "smart", setup_flow: Channel::SETUP_FLOW_GLOBAL, is_enable: true)}
  before(:each) do
    @recipient_1 = create(:sms_recipient, name: "test", phone: "85512345678", verboice_project_id: 1)
    @recipient_2 = create(:sms_recipient, name: "test", phone: "85510345678", verboice_project_id: 1)
    @external_sms_result = ExternalSmsResult.new("01012345678", "1111")
    allow(ExternalSmsResult).to receive(:recipients).and_return([@recipient_1, @recipient_2])
    allow(Channel).to receive(:suggested).and_return(smart)
  end

  describe ".recipients" do
    it {
      expect(ExternalSmsResult.recipients).to include @recipient_1
    }
  end

  describe "#message_options" do
    it "has 2 messages" do
      expect(@external_sms_result.message_options.length).to eq 2
    end
    it "returns message_options by recipient" do
      expect(@external_sms_result.message_options).to include({from: ENV['APP_NAME'], to: "sms://#{@recipient_1.phone}", body: "01012345678 has left voice message on call log 1111", suggested_channel: smart.name})
    end
  end

  describe "#translate_message" do
    it {
      expect(@external_sms_result.translate_message).to eq("01012345678 has left voice message on call log 1111")
    }
  end

  describe "#run" do
    it {
      @external_sms_result.run
      expect(enqueued_jobs.size).to eq(1)
    }
  end

end
