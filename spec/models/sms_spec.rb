require 'rails_helper'

RSpec.describe Sms, type: :model do
  before :each do
    @sms = Sms.instance
  end
  describe "#nuntium" do
    it "returns nuntium instance" do
      # expect(@sms).to hav_attr_accessor(:nuntium)
    end
    
  end
end
