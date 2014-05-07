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
  	users = []
  	Rsvp.where(event_id: self.id).each { |r| users << r.user_id }
  	#I should be adding this to an event object that is not an active record object
  	User.where(id: users)
  end

  def self.find_current_user_suggested_events current_user_id
	subscriptions = Subscription.where(user_id: current_user_id)
	interests = []
	subscriptions.each { |s| interests << s.interest_id }
	event_tags = EventTag.where interest_id: interests
	event_ids = []
	event_tags.each { |et| event_ids << et.event_id }
	event_ids.uniq!
	rsvps = Rsvp.where(user_id: current_user_id).where(event_id: event_ids).where(status: ['attending','declined'])
	rsvps.each { |r| event_ids.delete r.event_id }
	@suggested_events = Event.where(id: event_ids).where("event_date > ?", Time::now)
  @suggested_events.each do |event|
    event.status = :undecided
  end
  @suggested_events
  end

end
