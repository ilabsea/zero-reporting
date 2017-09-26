# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  description  :text(65535)
#  display_from :date
#  display_till :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  url_ref      :string(255)
#

class Event < ActiveRecord::Base
	include Event::Attachmentable, Event::DateRangeIdentifiable

	validates :description, presence: true
	validates :url_ref, :url => {:allow_blank => true}

	UPCOMING = 'upcoming'
	PAST = 'past'

	ANNOUNCEMENT_LISTING = 3

	def self.of_type type
		type === UPCOMING ? upcoming : past
	end

	def over?
		return display_till < Date.today if display_till
		return display_from < Date.today
	end

end
