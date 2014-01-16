class EventTag < ActiveRecord::Base
  belongs_to :event
  has_one :interest
  # attr_accessible :title, :body
end
