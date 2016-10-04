require 'rails_helper'

RSpec.describe Parser::PlaceAuditorParser, type: :model do
  let(:setting) { Setting::ReportSetting.new }
  let(:hc) { build(:hc) }
  let(:places) { [hc] }
  
  context '.parse' do
    context 'HC type' do
      it "should return reporter auditor" do
        auditor = Parser::PlaceAuditorParser.parse('HC', places, setting)

        expect(auditor).to be_a_kind_of Auditor::Places::ReporterAuditor
        expect(auditor.places).to eq [hc]
        expect(auditor.setting).to be_a_kind_of Setting::ReportSetting
      end
    end

    context 'OD or PHD type' do
      it "should return supervisor auditor" do
        auditor = Parser::PlaceAuditorParser.parse('OD', places, setting)

        expect(auditor).to be_a_kind_of Auditor::Places::SupervisorAuditor
        expect(auditor.places).to eq [hc]
        expect(auditor.setting).to be_a_kind_of Setting::ReportSetting
      end
    end
  end
end
