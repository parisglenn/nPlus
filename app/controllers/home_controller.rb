class HomeController < ApplicationController
	before_filter :authenticate_user!
  def index
  	if current_user
  		#to do - add geo parameters to these as well
  		@user_events = Rsvp.find_current_user_attending_events current_user.id
  		@suggested_events = Event.find_current_user_suggested_events current_user.id
  		@new_rsvp = Rsvp.new
	else
		redirect_to log_in_path#new_user_session_path
	end
  end
end
