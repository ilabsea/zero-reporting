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

require 'rails_helper'

RSpec.describe Event, type: :model do
  context "validations" do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:attachments) }

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
    	let(:event) { Event.new(description: 'test', from_date: Date.today, to_date: Date.today + 1.day, attachments: [build(:event_attachment)])}
    	
    	it { expect { event.save! }.to change(Event, :count).by(1) }
    end
  end

  context "#due_date" do
  	context "has only from date" do
  		let(:event) { build(:event, from_date: Date.new(2016,1,1), to_date: nil)}

  		it { expect(event.due_date).to eq("2016-01-01")}
  	end

  	context "from date and to date are on the same date" do
  		let(:event) { build(:event, from_date: Date.new(2016,1,1), to_date: Date.new(2016,1,1))}

  		it { expect(event.due_date).to eq("2016-01-01")}
  	end

  	context "from date and to date are difference" do
  		let(:event) { build(:event, from_date: Date.new(2016,1,1), to_date: Date.new(2016,2,1))}

  		it { expect(event.due_date).to eq("2016-01-01 to 2016-02-01")}
  	end
  end

end
