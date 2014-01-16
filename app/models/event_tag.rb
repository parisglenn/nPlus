class EventTag < ActiveRecord::Base
  belongs_to :event
  belongs_to :interest
  # attr_accessible :title, :body
end
