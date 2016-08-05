# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  description :text(65535)
#  from_date   :date
#  to_date     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Event < ActiveRecord::Base
	include Event::Attachmentable, Event::DateRangeIdentifiable

	UPCOMING = 'upcoming'
	PAST = 'past'

	ANNOUNCEMENT_LISTING = 3

	def self.of_type type
		type === UPCOMING ? upcoming : past
	end

	def over?
		return to_date < Date.today if to_date
		return from_date < Date.today
	end

end
