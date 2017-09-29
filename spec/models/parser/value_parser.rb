require 'rails_helper'

RSpec.describe Parser::ValueParser, type: :model do
  describe ".parser" do
    context 'with valid value' do
      it { expect(Parser::ValueParser.new('1').parse).to eq(1) }
      it { expect(Parser::ValueParser.new('01').parse).to eq(1) }
    end
    context 'with invalid value' do
      it { expect(Parser::ValueParser.new('*1').parse).to eq(1) }
      it { expect(Parser::ValueParser.new('*1*10').parse).to eq(0) }
    end
  end
end
