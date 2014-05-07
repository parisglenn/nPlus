class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :host, :status, :user_id, :event_id

  #valid status is any of attending, declined, maybe

	# scope :find_current_user_events, lambda { |user|
	# 	where(:user_id => user.id).order('created_at DESC')
	# }

	def self.find_current_user_attending_events current_user_id
		rsvps = Rsvp.where(user_id: current_user_id).where(status: "attending")
		event_ids = []
		rsvps.each { |r| event_ids << r.event_id }
		@user_events = Event.where(id: event_ids).where('event_date > ?', Time::now)
		@user_events.each do |event|
			event.status = :attending
		end
		@user_events
	end

end