class HomeController < ApplicationController
	before_filter :authenticate_user!
  def index
  	if current_user
      geos = UserGeo.where user_id: current_user.id
      subscriptions = Subscription.where user_id: current_user.id
      if geos.count == 0 || subscriptions.count == 0
        flash[:notice] = "Please complete your account preferences below"
        redirect_to define_profile_path
      else
        @user_events = current_user.find_attending_events
        @suggested_events = current_user.find_suggested_events
        @new_rsvp = Rsvp.new #for events
        @next_round_up_match = RoundUpMatch.get_next_match current_user.id 
        if @next_round_up_match
          @round_up_match_user = @next_round_up_match.get_other_user current_user.id
          @round_up_match_rsvp = RoundUpMatchUser.where(round_up_match_id: @next_round_up_match.id)
        end
        @todays_office_hours = UserOfficeHour.where("day_of_week = ?", Date.today.strftime("%A"))
      end
	else
		redirect_to log_in_path#new_user_session_path
	end
  end
end
