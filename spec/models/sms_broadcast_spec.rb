require 'rails_helper'

RSpec.describe SmsBroadcast, type: :model do
  include ActiveJob::TestHelper

  let(:sms_broadcaster) { SmsBroadcast.new('Testing') }

  describe "#broadcast_to" do
    context "raise nuntium exception when there is no any active channel" do
      let(:users) { [build(:user, phone: '1000')] }

      it { expect { sms_broadcaster.broadcast_to users }.to raise_error(Nuntium::Exception) }
    end

    context "ignore adding sms to queue when there is no any users" do
      it {
        expect(SmsQueueJob).to receive(:perform_later).with({receivers: ['1000'], body: 'Testing'}).never

        sms_broadcaster.broadcast_to []

        expect(enqueued_jobs.size).to eq(0)
      }
    end

    context "adding a sms to queue for every user who has phone number when it has active channels" do
      let(:user) { build(:user, phone: '1000') }
      let(:user_without_phone_number) { build(:user, phone: nil) }
      let(:users) { [user, user_without_phone_number] }
      let(:log_type) { create(:log_type, name: :broadcast) }
      let(:sms) { Sms::Message.new('1000', 'Testing', nil, log_type) }

      before(:each) do
        allow(Channel).to receive(:has_active?).and_return(true)
        allow(Sms::Message).to receive(:new).with('1000', 'Testing', nil, log_type).and_return(sms)
      end

      it {
        sms_broadcaster.broadcast_to users

        expect(enqueued_jobs.size).to eq(1)
        expect(enqueued_jobs.first[:args].first).to eq({ to: '1000', body: 'Testing', suggested_channel: nil, type: log_type })
      }
    end
  end
end
