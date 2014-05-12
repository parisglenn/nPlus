class HomeController < ApplicationController
	before_filter :authenticate_user!
  def index
  	if current_user
  		#to do - add geo parameters to these as well
  		@user_events = current_user.find_attending_events
  		@suggested_events = current_user.find_suggested_events
  		@new_rsvp = Rsvp.new
	else
		redirect_to log_in_path#new_user_session_path
	end
  end
end
