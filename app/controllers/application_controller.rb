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

  # private
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
end
