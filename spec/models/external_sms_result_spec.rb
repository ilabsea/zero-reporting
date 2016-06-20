require 'rails_helper'

RSpec.describe ExternalSmsResult, type: :model do
  include ActiveJob::TestHelper

  let(:setting){create(:external_sms_setting, is_enable: true, message_template: "{{caller_phone}} has left voice message on call log {{call_log_id}}", recipients: ['85512345678', '8551012345678'])}

  before(:each) do
    @external_sms_result = ExternalSmsResult.new(setting, "8551012345678", "1111")
  end

  describe ".recipients" do
    it { expect(@external_sms_result.recipients).to include "85512345678" }
  end

  describe "#to_sms_message" do
    it {
      expect(@external_sms_result.to_sms_message).to be_kind_of(Sms::Message)
      expect(@external_sms_result.to_sms_message.receivers).to eq(['85512345678', '8551012345678'])
    }
  end

  describe "#interpolate_variable_values" do
    it { expect(@external_sms_result.interpolate_variable_values).to eq("8551012345678 has left voice message on call log 1111") }
  end

  describe "#run" do
    it {
      @external_sms_result.run
      expect(enqueued_jobs.size).to eq(1)
    }
  end

end
