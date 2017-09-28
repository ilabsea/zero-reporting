module Event::DateRangeIdentifiable
	extend ActiveSupport::Concern

	included do
		validates :display_from, date: { after_or_equal_to: Proc.new { Date.today }, message: 'must be after or equal to today' },
  	on: :create

		validates :display_till, date: { allow_blank: true, after_or_equal_to: :display_from, message: 'must be after or equal to display_from date' }
	end


end
