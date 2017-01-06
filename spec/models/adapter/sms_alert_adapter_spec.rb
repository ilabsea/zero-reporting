require 'rails_helper'

RSpec.describe Adapter::SmsAlertAdapter, type: :model do
  include ActiveJob::TestHelper

  let(:tel) { Tel.new('1000') }
  let(:channel) { create(:channel, name: 'Channel1') }

  before(:each) do
    allow(Tel).to receive(:new).with('1000').and_return(tel)
    allow(Tel).to receive(:new).with('2000').and_return(tel)
    allow(Channel).to receive(:suggested).with(tel).and_return(channel)
  end

  describe '#process' do
    context 'external service alert' do
      let(:setting) { create(:external_sms_setting, is_enable: true, message_template: '{{caller_phone}} has left voice message on call log {{call_log_id}}', recipients: ['1000', '2000']) }
      let(:alert) { Alerts::ExternalServiceAlert.new(setting, '2020', '1') }

      let(:adapter) { Adapter::SmsAlertAdapter.new(alert) }

      it 'enqueue an alert job to queue' do
        adapter.process

        expect(enqueued_jobs.size).to eq(2)

        expect(enqueued_jobs.first[:job]).to eq(SmsQueueJob)
        first_queued = enqueued_jobs.first[:args].first.delete_if { |k, v| k === '_aj_symbol_keys' }
        expect(first_queued).to eq({ 'to' => '1000', 'body' => '2020 has left voice message on call log 1', 'suggested_channel' => { "_aj_globalid" => "gid://#{ENV['APP_NAME'].split(' ').join("-").downcase}/Channel/#{channel.id}" }, 'type' => nil})
        
        expect(enqueued_jobs.last[:job]).to eq(SmsQueueJob)
        last_queued = enqueued_jobs.last[:args].first.delete_if { |k, v| k === '_aj_symbol_keys' }
        expect(last_queued).to eq({ 'to' => '2000', 'body' => '2020 has left voice message on call log 1', 'suggested_channel' => { "_aj_globalid" => "gid://#{ENV['APP_NAME'].split(' ').join("-").downcase}/Channel/#{channel.id}" }, 'type' => nil})
      end
    end

    context 'report case alert' do
      let(:hc) { create(:hc) }
      let(:user) { create(:user, phone: '1000', place: hc) }
      let(:report) { create(:report, user: user, phone: '2000') }
      let(:week) { Calendar::Year.new(2016).week(1) }
      let!(:setting) { create(:alert_setting, is_enable_sms_alert: true, message_template: 'This is the alert on {{week_year}} for {{reported_cases}}', verboice_project_id: 24, recipient_type: ['OD', 'HC']) }
      let(:alert) { Alerts::ReportCaseAlert.new(setting, report, week) }

      let(:adapter) { Adapter::SmsAlertAdapter.new(alert) }

      it 'enqueue an alert job to queue' do
        adapter.process

        expect(enqueued_jobs.size).to eq(1)

        expect(enqueued_jobs.first[:job]).to eq(SmsQueueJob)
        first_queued = enqueued_jobs.first[:args].first.delete_if { |k, v| k === '_aj_symbol_keys' }
        expect(first_queued).to eq({ 'to' => '1000', 'body' => 'This is the alert on w1-2016 for ', 'suggested_channel' => { '_aj_globalid' => "gid://#{ENV['APP_NAME'].split(' ').join("-").downcase}/Channel/#{channel.id}" }, 'type' => nil })
      end
    end

    context 'broadcast alert' do
      let(:user_1) { build(:user, phone: '1000') }
      let(:user_2) { build(:user, phone: '2000') }
      let(:alert) { Alerts::BroadcastAlert.new([user_1, user_2], 'Testing message') }

      let(:adapter) { Adapter::SmsAlertAdapter.new(alert) }

      it 'enqueue an alert job to queue' do
        adapter.process

        expect(enqueued_jobs.size).to eq(2)

        expect(enqueued_jobs.first[:job]).to eq(SmsQueueJob)
        first_queued = enqueued_jobs.first[:args].first.delete_if { |k, v| k === '_aj_symbol_keys' }
        expect(first_queued).to eq({ 'to' => '1000', 'body' => 'Testing message', 'suggested_channel' => { '_aj_globalid' => "gid://#{ENV['APP_NAME'].split(' ').join("-").downcase}/Channel/#{channel.id}" }, 'type' => nil })
        
        expect(enqueued_jobs.last[:job]).to eq(SmsQueueJob)
        last_queued = enqueued_jobs.last[:args].first.delete_if { |k, v| k === '_aj_symbol_keys' }
        expect(last_queued).to eq({ 'to' => '2000', 'body' => 'Testing message', 'suggested_channel' => { '_aj_globalid' => "gid://#{ENV['APP_NAME'].split(' ').join("-").downcase}/Channel/#{channel.id}" }, 'type' => nil })
      end
    end
  end
end
