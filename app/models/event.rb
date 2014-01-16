class Event < ActiveRecord::Base
  belongs_to :geo
  has_many :event_tag
  attr_accessible :end_time, :event_date, :location, :name, :start_time
  accepts_nested_attributes_for :event_tag
end
