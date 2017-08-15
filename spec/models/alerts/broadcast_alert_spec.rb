require 'rails_helper'

RSpec.describe Alerts::BroadcastAlert, type: :model do

  let(:user_1) { build(:user, phone: '1000') }
  let(:user_2) { build(:user, phone: '2000', sms_alertable: true) }
  let(:user_3) { build(:user, phone: '') }
  let(:user_4) { build(:user, phone: nil) }
  let(:user_5) { build(:user, phone: '5000', sms_alertable: false, disable_alert_reason: 'no longer reason') }

  let(:alert) { Alerts::BroadcastAlert.new([user_1, user_2, user_3, user_4], 'Testing message') }

  describe '#recipients' do
    it { expect(alert.recipients).to eq(['1000', '2000']) }
  end

end
