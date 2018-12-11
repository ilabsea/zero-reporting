require 'elasticsearch/model'

module Reports::Elasticsearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name  "zero_reports"
    document_type "report"

    def as_indexed_json(options={})
      self.as_json(
        include: { user: {only: :username},
                   place: {only: [:name, :code, :kind_of]},
                   report_variables: {only: [:variable_id, :type, :value]}
                 })
    end
  end
end

