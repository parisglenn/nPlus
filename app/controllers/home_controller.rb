class HomeController < ApplicationController
	before_filter :authenticate_user!
  def index
  	if current_user
  		#to do - add geo parameters to these as well
  		rsvps = Rsvp.where user_id: current_user.id
  		event_ids = []
  		rsvps.each { |r| event_ids << r.event_id }
  		@user_events = Event.where(id: event_ids).where('event_date > ?', Time::now)

  		subscriptions = Subscription.where user_id: current_user.id
  		interests = []
  		subscriptions.each { |s| interests << s.interest_id }
  		event_tags = EventTag.where interest_id: interests
  		event_ids = []
  		event_tags.each { |et| event_ids << et.event_id }
  		@suggested_events = Event.where(id: event_ids.uniq).where('event_date > ?', Time::now)
  		puts "user events"
  		puts @user_events
  		puts "suggested events"
  		puts @suggested_events
	else
		redirect_to log_in_path#new_user_session_path
	end
  end
end
