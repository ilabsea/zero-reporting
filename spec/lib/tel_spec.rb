require "rails_helper"

describe Tel, :type => :model do
  context 'without prefix' do
    it { expect(Tel.new('012999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('85512999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('+85512999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('855012999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('+855012999999').without_prefix).to eq('12999999') }

    it { expect(Tel.new('12999999').without_prefix).to eq('12999999') }
  end
end
