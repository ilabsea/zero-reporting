require 'rails_helper'

RSpec.describe Reports::Elasticsearch, type: :model do
  let(:app_name) { Rails.application.class.parent_name.underscore }
  let(:report) { create(:report) }

  it 'index_name is the application name `zero_reporting`' do
    expect(report.__elasticsearch__.index_name).to eq(app_name)
  end

  it 'document_type is model name' do
    expect(report.__elasticsearch__.document_type).to eq(Report.name.underscore)
  end

  describe 'as_indexed_json' do
    let!(:variable) { create(:variable, verboice_name: 'var_1') }
    let!(:report_variable) { create(:report_variable, report: report, variable: variable) }
    let!(:document) { report.reload.as_indexed_json }

    it 'includes users' do
      expect(document).to include_json(
        user: { username: report.user.username }
      )
    end

    it 'includes place' do
      expect(document).to include_json(
        place: {
          name: report.place.name,
          code: report.place.code,
          kind_of: report.place.kind_of
        }
      )
    end

    it 'includes report_variables' do
      expect(document).to include_json(
        report_variables: [
          { verboice_name: variable.verboice_name, type: '', value: nil}
        ]
      )
    end
  end
end
