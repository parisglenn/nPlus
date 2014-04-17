class EventTag < ActiveRecord::Base
  belongs_to :event
  belongs_to :interest
  attr_accessible :event_id, :interest_id
end
