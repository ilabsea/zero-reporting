require 'elasticsearch/model'

module Reports::Elasticsearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name    Settings.elasticsearch.index_name
    document_type Settings.elasticsearch.document_type

    def as_indexed_json(options={})
      option = self.as_json(
        include: { user: {only: :username},
                   place: {only: [:name, :code, :kind_of]},
                 })

      option['report_variables'] = []

      self.report_variables.includes(:variable).each do |report_variable|
        option['report_variables'].push(
          {
            verboice_name: report_variable.variable.verboice_name,
            type: report_variable.type,
            value: report_variable.value
          }
        )
      end

      option
    end
  end
end
