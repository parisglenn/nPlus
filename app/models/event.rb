class Event < ActiveRecord::Base
  belongs_to :geo
  attr_accessible :end_time, :event_date, :location, :name, :start_time
end
