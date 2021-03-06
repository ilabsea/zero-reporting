require 'rails_helper'

RSpec.describe SmsBroadcastsController, type: :controller do

  let(:user) { build(:user, role: User::ROLE_ADMIN) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "create" do
    context "without locations" do
      it "should has status redirect" do
        post :create, sms_broadcast: { message: 'Testing' }

        expect(response).to have_http_status(:found) #302
      end

      it "should redirect to index" do
        post :create, sms_broadcast: { message: 'Testing' }

        expect(response).to redirect_to(sms_broadcasts_path)
      end
    end

    context "with locations" do
      it "should receive level " do
        allow(Place).to receive(:level).with('PHD').and_return([])

        post :create, sms_broadcast: { message: 'Testing', level: 'PHD' }

        expect(response).to redirect_to(sms_broadcasts_path)
        expect(flash[:notice]).to be_present
      end

      it "should receive level and locations " do
        allow(Place).to receive(:level).with('PHD').and_return(Place)
        allow(Place).to receive(:in).with(["1", "2"]).and_return([])

        post :create, sms_broadcast: { message: 'Testing', level: 'PHD', locations: ["1", "2"] }

        expect(response).to redirect_to(sms_broadcasts_path)
        expect(flash[:notice]).to be_present
      end
    end
  end

end
