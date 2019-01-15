require 'elasticsearch/model'

module Reports::Elasticsearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name Rails.application.class.parent_name.underscore
    document_type self.name.underscore

    def as_indexed_json(options={})
      option = self.as_json(
        include: { user: {only: :username},
                   place: {only: [:name, :code, :kind_of]},
                 })

      option['report_variables'] = []

      self.report_variables.includes(:variable).each do |report_variable|
        option['report_variables'].push(
          {
            verboice_name: report_variable.variable.try(:verboice_name),
            type: report_variable.type,
            value: report_variable.value
          }
        )
      end

      option
    end
  end
end
