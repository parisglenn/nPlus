class Event < ActiveRecord::Base
  belongs_to :geo
  has_many :interest
  has_many :event_tag
end
