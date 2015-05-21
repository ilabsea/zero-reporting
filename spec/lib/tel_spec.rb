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

  context "area code" do
    it { expect(Tel.new('012999999').area_code).to eq('12') }
    it { expect(Tel.new('85512999999').area_code).to eq('12') }
    it { expect(Tel.new('+85512999999').area_code).to eq('12') }
    it { expect(Tel.new('855012999999').area_code).to eq('12') }
    it { expect(Tel.new('+855012999999').area_code).to eq('12') }

    it { expect(Tel.new('010999999').area_code).to eq('10') }
    it { expect(Tel.new('85510999999').area_code).to eq('10') }
    it { expect(Tel.new('+85510999999').area_code).to eq('10') }
    it { expect(Tel.new('855010999999').area_code).to eq('10') }
    it { expect(Tel.new('+855010999999').area_code).to eq('10') }

    it { expect(Tel.new('1109999999').area_code).to eq(nil) }
    it { expect(Tel.new('+1109999999').area_code).to eq(nil) }
  end
end
