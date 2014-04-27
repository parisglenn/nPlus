class Event < ActiveRecord::Base
  belongs_to :geo
  has_many :event_tags
  has_many :rsvps
  attr_accessible :end_time, :event_date, :location, :name, :start_time, :geo, :description
  accepts_nested_attributes_for :event_tags
end
