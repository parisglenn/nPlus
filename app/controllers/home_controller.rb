class HomeController < ApplicationController
	before_filter :authenticate_user!
  def index
  	if current_user#user_signed_in?
  		puts "user is signed in"
	else
		redirect_to log_in_path#new_user_session_path
	end
  end
end
