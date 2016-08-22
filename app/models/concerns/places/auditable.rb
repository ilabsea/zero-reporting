module Places::Auditable
  extend ActiveSupport::Concern

  included do
    has_many :reports, dependent: :nullify
  end

  module ClassMethods
    def missing_report_in days
      where(kind_of: HC.kind).where.not(id: Report.where('called_at >= ?', days.ago).select(:place_id).group('place_id').having('count(id) > 0'))
    end
  end
end
