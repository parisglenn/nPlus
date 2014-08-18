class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  #helper_method :current_user

	def authorize_admin
	  unless current_user.admin
	    flash[:error] = "You have been redirected as you do not have permission to access the requested page"
	    redirect_to root_path
	    false
	  end
	end

  private

    def format_date_save date
      date_array = date.split("/")
      month = date_array[0]
      day   = date_array[1] 
      year  = date_array[2]
      Date.new(year.to_i, month.to_i, day.to_i)
    end

    def format_date_display
      original_date = @event.event_date.dup
      @event.event_date = "#{original_date.month}/#{original_date.day}/#{original_date.year}"
    end
end
