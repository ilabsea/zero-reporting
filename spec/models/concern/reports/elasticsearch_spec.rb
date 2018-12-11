require 'rails_helper'

RSpec.describe Reports::Elasticsearch, type: :model do
  let(:report) { create(:report) }

  it 'index_name is zero_reports' do
    expect(report.__elasticsearch__.index_name).to eq(Settings.elasticsearch.index_name)
  end

  it 'document_type is report' do
    expect(report.__elasticsearch__.document_type).to eq(Settings.elasticsearch.document_type)
  end

  describe 'as_indexed_json' do
    let!(:variable) { create(:variable) }
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
          { variable_id: variable.id, type: '', value: nil}
        ]
      )
    end
  end
end
