class EventTag < ActiveRecord::Base
	attr_accessible :event_id :interest_id
	accepts_nested_attributes_for :event, :interest
  belongs_to :event
  belongs_to :interest
end
