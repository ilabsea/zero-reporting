module Event::DateRangeIdentifiable
	extend ActiveSupport::Concern

	included do
		validates :from_date, date: { after_or_equal_to: Proc.new { Date.today }, message: 'must be after or equal to today' },
  	on: :create

		validates :to_date, date: { allow_blank: true, after_or_equal_to: :from_date, message: 'must be after or equal to from_date' }
	end

	module ClassMethods
		def past(days = nil)
			return where("from_date < ?", Date.today) if days.nil?
			where(from_date: (Date.today - days)...Date.today)
		end

		def upcoming(days = nil)
			return where("from_date >= ?", Date.today) if days.nil?
			where(from_date: Date.today...(Date.today + days))
		end
	end

end
