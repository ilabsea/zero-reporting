require 'rails_helper'

RSpec.describe WeeksController, type: :controller do
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(build(:user))
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "returns available weeks" do
      get :index, year: 2016

      expect(assigns(:weeks)).to be_a(Array)
    end
  end

end
