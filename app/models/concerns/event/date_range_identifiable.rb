module Event::DateRangeIdentifiable
	extend ActiveSupport::Concern

	included do
		validates :display_from, date: { after_or_equal_to: Proc.new { Date.today }, message: 'must be after or equal to today' },
  	on: :create

		validates :display_till, date: { allow_blank: true, after_or_equal_to: :display_from, message: 'must be after or equal to display_from date' }
	end

	module ClassMethods
		def past(days = nil)
			return where("display_from < ?", Date.today) if days.nil?
			where(display_from: (Date.today - days)...Date.today)
		end

		def upcoming(days = nil)
			return where("display_from >= ?", Date.today) if days.nil?
			where(display_from: Date.today...(Date.today + days))
		end
	end

end
