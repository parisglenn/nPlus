class Event < ActiveRecord::Base
  belongs_to :geo
  has_many :event_tags
  has_many :rsvps
  attr_accessible :end_time, :event_date, :location, :name, :start_time, :geo, :description
  accepts_nested_attributes_for :event_tags

  def status=(status)
    @status = status
  end

  def status
    @status
  end

  def attending_users
  	users = Rsvp.where(event_id: self.id).map { |r| r.user_id }
  	#I should be adding this to an event object that is not an active record object
  	User.where(id: users)
  end

end
