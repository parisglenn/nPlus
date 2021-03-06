module ApplicationHelper
	def generate_office_dropdown
		@offices = Office.all
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

	def generate_geo_dropdown
		@geos = Geo.all
		@geo_dropdown_list = Array.new

		@geos.each do |geo|
			@geo_dropdown_list << ["#{geo.name}", geo.id.to_i]
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
end
