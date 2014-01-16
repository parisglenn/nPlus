module UsersHelper
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

end
