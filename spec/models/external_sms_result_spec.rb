require 'rails_helper'

RSpec.describe ExternalSmsResult, type: :model do
  include ActiveJob::TestHelper
  let(:smart){create(:channel, name: "smart", setup_flow: Channel::SETUP_FLOW_GLOBAL, is_enable: true)}
  let(:setting){create(:external_sms_setting, is_enable: true, message_template: "{{caller_phone}} has left voice message on call log {{call_log_id}}", recipients: ["85512345678", "8551012345678"])}
  before(:each) do
    @external_sms_result = ExternalSmsResult.new(setting, "8551012345678", "1111")
    allow(Channel).to receive(:suggested).and_return(smart)
  end

  describe ".recipients" do
    it {
      expect(@external_sms_result.recipients).to include "85512345678"
    }
  end

  describe "#message_options" do
    it "has 2 messages" do
      expect(@external_sms_result.message_options.length).to eq 2
    end
    it "returns message_options by recipient" do
      expect(@external_sms_result.message_options).to include({from: ENV['APP_NAME'], to: "sms://8551012345678", body: "8551012345678 has left voice message on call log 1111", suggested_channel: smart.name})
    end
  end

  describe "#translate_message" do
    it {
      expect(@external_sms_result.translate_message).to eq("8551012345678 has left voice message on call log 1111")
    }
  end

  describe "#run" do
    it {
      @external_sms_result.run
      expect(enqueued_jobs.size).to eq(1)
    }
  end

end
