# == Schema Information
#
# Table name: report_variables
#
#  id           :integer          not null, primary key
#  report_id    :integer
#  variable_id  :integer
#  type         :string(255)
#  value        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  has_audio    :boolean          default(FALSE)
#  listened     :boolean          default(FALSE)
#  token        :string(255)
#  is_alerted   :boolean          default(FALSE)
#  exceed_value :string(255)
#
# Indexes
#
#  index_report_variables_on_report_id    (report_id)
#  index_report_variables_on_variable_id  (variable_id)
#

require 'rails_helper'

RSpec.describe ReportVariable, type: :model do
  let(:variable) { create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, alert_method: 'formula') }
  let(:variable_with_invalid_method) { create(:variable, name: 'invalid', verboice_id: 10, verboice_name: 'invalid', verboice_project_id: 24, alert_method: '') }

  let(:week){ Calendar.week(Date.new(2016,02,10)) }
  let(:od){ create(:od) }
  let(:hc){ create(:hc, name: 'Testing HC', parent: od) }
  let(:strategy) { Strategies::Thresholds::FormulaStrategy.new }

  describe "#check_alert_for" do
    context 'with formula alert method' do
      let(:report_variable) { create(:report_variable, variable: variable, value: 50) }

      before(:each) do
        allow(Strategies::ThresholdStrategy).to receive(:get).with('formula').and_return(strategy)
      end

      it {
        expect(report_variable).to receive(:set_alert).with(strategy, week, hc)
        report_variable.check_alert_for(week, hc)
      }
    end

    context 'with case base alert method' do
      let(:variable_case_base) { create(:variable, name: 'death', verboice_id: 99, verboice_name: 'death', verboice_project_id: 24, alert_method: 'case_base') }
      let(:report_variable) { create(:report_variable, variable: variable_case_base, value: 50) }

      before(:each) do
        allow(Strategies::ThresholdStrategy).to receive(:get).with('case_base').and_return(strategy)
      end

      it {
        expect(report_variable).to receive(:set_alert).with(strategy, week, hc)
        report_variable.check_alert_for(week, hc)
      }
    end

    context 'without alert method' do
      let(:report_variable) { create(:report_variable, variable: variable_with_invalid_method, value: 20) }

      it {
        expect { report_variable.check_alert_for(week, hc) }.to raise_error(StandardError)
      }
    end
  end

  describe "#set_alert" do
    let(:context) { ThresholdContext.new(strategy) }
    let(:threshold) { Threshold.new(:formula, variable, hc, week, 10) }

    let(:report_variable) { create(:report_variable, variable: variable, value: 50) }

    before(:each) do
      allow(strategy).to receive(:baseline_of).with(variable, hc, week).and_return(threshold)
    end

    it {
      expect(report_variable).to receive(:mark_as_reaching_alert_with_exceed_value).with(40)

      report_variable.set_alert(strategy, week, hc)
    }
  end

  describe '#perform_cheked_alert?' do
    context 'when variable has no alert_method and report_variable has value' do
      let(:age) { create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, alert_method: 'none') }
      let(:report_variable) { create(:report_variable_value, variable: age, value: 50) }
      it {
        expect(report_variable.alert_defined?).to eq(false)
      }
    end

    context 'when variable has alert_method and zero report_variable value' do
      let(:age) { create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, alert_method: 'case_base') }
      let(:report_variable) { create(:report_variable_value, variable: age, value: 0) }
      it {
        expect(report_variable.alert_defined?).to eq(false)
      }
    end

    context 'when variable has alert_method and report_variable has value' do
      let(:age) { create(:variable, name: 'age', verboice_id: 91, verboice_name: 'age', verboice_project_id: 24, alert_method: 'formula') }
      let(:report_variable) { create(:report_variable_value, variable: age, value: 50) }
      it {
        expect(report_variable.alert_defined?).to eq(true)
      }
    end

  end

end
