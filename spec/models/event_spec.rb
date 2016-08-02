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
#  url_ref     :string(255)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  context "validations" do
    it { should validate_presence_of(:description) }

    context "invalid" do
	    it "from date must be presence" do
	    	event = build(:event, from_date: nil)
	    	expect { event.save }.to change(Event, :count).by(0)
	    end

	    it "from date must be greater than or equal to today" do
	    	event = build(:event, from_date: Date.today - 1.day)
	    	expect { event.save }.to change(Event, :count).by(0)
	    end

	    it "to date must be greater than or equal from date" do
	    	event = build(:event, from_date: "2016-01-02", to_date: "2016-01-01")
	    	expect { event.save }.to change(Event, :count).by(0)
	    end
    end

    context "valid" do
    	let(:event) { Event.new(description: 'test', from_date: Date.today, to_date: Date.today + 1.day, attachments: [build(:event_attachment)]) }

    	it { expect { event.save! }.to change(Event, :count).by(1) }
    end
  end

end
