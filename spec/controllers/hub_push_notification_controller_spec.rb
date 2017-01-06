require 'rails_helper'

RSpec.describe HubPushNotificationsController, type: :controller do
  let(:od) { create(:od) }
  let(:place) { create(:hc, dhis2_organisation_unit_uuid: 'abacad') }
  let(:user) { create(:user, place: od) }
  let(:hc_user) { create(:user, place: place) }
  let(:report) { create(:report, reviewed: false, user: user) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    before(:each) do
      normal_user = UserContext::NormalUser.new(user)
      reports = [report]

      allow(UserContext).to receive(:for).with(user).and_return(normal_user)
      allow(normal_user).to receive(:reports).and_return(reports)
      allow(reports).to receive(:find).with(report.id.to_s).and_return(report)
    end

    context "failed" do
      it "return http status unprocessable_entity(422)" do
        post :create
        expect(response).to have_http_status(422)
      end

      it "raise an exception" do
        bypass_rescue
        expect { post :create }.to raise_error(Errors::UnprocessableEntity)
      end

      it "missing report parameter when report ID is missing" do
        post :create
        expect(response.body).to eq('Missing report parameter')
      end

      it "missing Hub configuration when hub is not configured" do
        allow(Setting).to receive(:hub_enabled?).and_return(false)
        post :create, report_id: report.id
        expect(response.body).to eq('Missing Hub configuration')
      end

      it "missing DHIS location reference when report location is not configured" do
        allow(Setting).to receive(:hub_enabled?).and_return(true)
        allow(Setting).to receive(:hub_configured?).and_return(true)

        post :create, report_id: report.id
        expect(response.body).to eq('Missing DHIS location reference')
      end
    end

    context "success" do
      let(:report) { create(:report, place: place, user: hc_user, reviewed: true) }
      
      before(:each) do
        allow(Setting).to receive(:hub_enabled?).and_return(true)
        allow(Setting).to receive(:hub_configured?).and_return(true)
      end

      it "return status 200" do
        expect(report).to receive(:notify_hub!)
        post :create, report_id: report.id
        expect(response).to have_http_status(200)
      end
    end
  end
end
