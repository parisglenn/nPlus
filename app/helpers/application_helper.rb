module ApplicationHelper
	def get_rsvp_buttons
		{:declined => "Can't Go", :attending => "I'm going", :maybe => "Maybe"}
	end

	def get_status_messages #change to get_rsvp_status_messages
		{attending: "You're going!", declined: "You're not going", maybe: "Maybe", undecided: "Not sure yet"}
	end

	def generate_office_dropdown
		@offices = Geo.where location_type: 'office'
		@offices_dropdown_list = Array.new

		@offices.each do |office|
			@offices_dropdown_list << ["#{office.name}", office.id.to_i]
		end

		return @offices_dropdown_list
	end

	def generate_team_dropdown
		@teams = Team.all
		@team_dropdown_list = Array.new

		@teams.each do |team|
			@team_dropdown_list << ["#{team.name}", team.id.to_i]
		end

		return @team_dropdown_list
	end

	def generate_geo_dropdown optional=false
		@geos = Geo.all
		@geo_dropdown_list = optional ? [[nil,nil]] : []

		@geos.each do |geo|
			@geo_dropdown_list << ["#{geo.name} (#{geo.location_type.classify})", geo.id.to_i]
		end

		return @geo_dropdown_list
	end

	def generate_time_dropdown
		@times = [["12:00AM", "000"], ["1:00AM", "100"],
							["2:00AM", "200"], ["3:00AM", "300"],
							["4:00AM", "400"], ["5:00AM", "400"],
							["6:00AM", "600"], ["7:00AM", "700"],
							["8:00AM", "800"], ["9:00AM", "900"],
							["10:00AM", "1000"], ["11:00AM", "1100"],
							["12:00AM", "1200"], ["1:00PM","1300"],
							["2:00PM", "1400"], ["3:00PM", "1500"],
							["4:00PM", "1600"], ["5:00PM", "1700"],
							["6:00PM", "1800"], ["7:00PM", "1900"],
							["8:00PM", "2000"], ["9:00PM", "2100"],
							["10:00PM", "2200"], ["11:00PM", "2300"]
							]
		return @times
	end

	def generate_days_of_week_dropdown
		[['Monday','Monday'],['Tuesday','Tuesday'],['Wednesday','Wednesday'],['Thursday','Thursday'],['Friday','Friday'],['Saturday','Saturday'],['Sunday','Sunday']]	
	end

	def get_days_of_week
		['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
	end

	def generate_notification_frequencies_dropdown
		[['Immediately','immediately'],['Daily','daily'],['Weekly','Weekly'],['Never','never']]
	end

	#format time - deprecating
	def ft hm
		minute = hm[-2..-1]
		hour = hm[0...-2]
		hemiday = "am"
		if hour.to_i > 12
			hemiday = "pm"
			hour=(hour.to_i - 12).to_s
		end
		hour+':'+minute+' '+hemiday
	end

	def f_time full_time
		full_time.strftime("%I:%M %p")
	end

	#make a round_up_time into a string that is html form friendly
	def concat_rut round_up_time
		round_up_time.day+'-'+round_up_time.start_hour
	end

	def uncat_rut round_up_time
		day, hour = round_up_time.split('-')
		return day, hour
	end
end
