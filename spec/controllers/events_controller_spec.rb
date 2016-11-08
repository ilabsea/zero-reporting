require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:user) { build(:user, role: User::ROLE_ADMIN) }

  let(:valid_attributes) {
    {
      description: "1", 
      from_date: Date.today, 
      to_date: Date.today, 
      attachments_attributes: {
        "0" => {
         file: File.open(File.join(Rails.root, 'spec', 'fixtures', 'test.pdf'))
        }
      }
    }
  }

  let(:invalid_attributes) {
    { description: 'test' }
  }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET #new" do
    it "assigns a new event as @event" do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, {:event => valid_attributes}
        }.to change(Event, :count).by(1)
      end

      it "creates a new Event attachment" do
        expect {
          post :create, {:event => valid_attributes}
        }.to change(EventAttachment, :count).by(1)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_attributes}
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, {:id => event.to_param}
      }.to change(Event, :count).by(-1)
    end
  end

end
