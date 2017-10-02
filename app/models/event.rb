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
#  ord          :integer
#  is_enabled   :boolean          default(FALSE)
#

class Event < ActiveRecord::Base
	include Event::Attachmentable, Event::DateRangeIdentifiable

	validates :description, presence: true
	validates :url_ref, :url => {:allow_blank => true}
	validates_numericality_of :ord, :greater_than => 0, allow_nil: true

	scope :ordered, -> { order('ord, display_from') }

	before_create :set_default_ord

	UPCOMING = 'upcoming'
	PAST = 'past'

	ANNOUNCEMENT_LISTING = ENV['ANNOUNCEMENT_LISTING'].to_i

	def self.of_type type
		type === UPCOMING ? upcoming : past
	end

	def self.past
		where(is_enabled: false).ordered
	end

	def self.upcoming
		where(is_enabled: true).ordered
	end

	def self.announcing
		upcoming.limit(Event::ANNOUNCEMENT_LISTING)
	end

	def self.disable_past_event
		Event.transaction do
      Event.find_each(batch_size: 100) do |event|
				event.mark_as_disabled if event.over?
      end
    end
	end

	def enabled?
		self.is_enabled
	end

	def over?
		return display_till < Date.today if display_till
		return display_from < Date.today
	end

	def announcing?
		return false if !self.is_enabled
		Event.announcing.any? {|event| event.id == self.id}
	end

	private
	def set_default_ord
		self.ord = 99 if self.ord.blank?
	end

	def mark_as_disabled
		self.is_enabled = false
		self.save
	end

end
