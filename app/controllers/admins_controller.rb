class AdminsController < ApplicationController
	def hub
		@geos = Geo.all
		@interests = Interest.all
		@round_up_times = RoundUpTime.all
		@users = User.all
		render 'admin/hub'
	end
end