class RsvpsController < ApplicationController
	def create
		@rsvp = Rsvp.where(event_id: params[:event_id]).where(user_id: params[:user_id]).last
		unless @rsvp
			@rsvp = Rsvp.new
			@rsvp.user_id = params[:user_id]
			@rsvp.event_id = params[:event_id]
		end
		@rsvp.status = params[:status]
		if @rsvp.save
			case params[:respond_with]
			when "events"
				@user_events = Rsvp.find_current_user_attending_events @rsvp.user_id
				redirect_to root_path
				#render partial: 'events/user_events'  -- when i use an ajax call
			when "event"
				render text: "We'll see you there!"
			end
		else
			flash[:error] = "Unable to update event"
			redirect_to root_path
		end  
	end
end