require 'rails_helper'

RSpec.describe Blacklist, type: :model do

  before(:each) do
    Setting.blacklist_numbers = ['010', '011']
  end

  describe 'exist?' do
    context 'when blacklist numbers is empty' do
      let(:tel) { Tel.new('012') }

      before(:each) do
        Setting.blacklist_numbers = []
      end
      
      it { expect(Blacklist.exist?(tel)).to eq(false) }
    end

    context 'when phone number does not exist in blacklist numbers' do
      let(:tel) { Tel.new('012') }

      it { expect(Blacklist.exist?(tel)).to eq(false) }
    end

    context 'when phone number exist in blacklist numbers' do
      context 'with zero(0) preffix' do
        let(:tel) { Tel.new('010') }

        it { expect(Blacklist.exist?(tel)).to eq(true) }
      end

      context 'with country code preffix' do
        let(:tel) { Tel.new('+85510') }

        it { expect(Blacklist.exist?(tel)).to eq(true) }
      end

      context 'without preffix' do
        let(:tel) { Tel.new('10') }

        it { expect(Blacklist.exist?(tel)).to eq(true) }
      end
    end
  end
end
