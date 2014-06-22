class RoundUp
	def initialize
		@offices = Office.all
		@round_up_times = RoundUpTime.all
		@users = User.all
		#@past_matches = RoundUpMatch.all #I don't think this table will have any useful info
		@user_matches = RoundUpMatchUser.all
		@user_availabilities = RoundUpUserAvailability.all
	end

end

class MatchUser
	def initialize
		@matched_this_week = false
		@availabilities = []#[day_of_week][office]
	end
end

class MatchGroup
	#by match time, by office
	def initialize office_id, round_up_time_id
		@office_id = office_id
		@round_up_time_id = round_up_time_id
		@date = get_date
		@users = []
	end
end

class generate_matches
	def initialize
		@round_up = RoundUp.new
		@match_groups = get_match_groups
	end

	def get_match_groups
		match_groups = []
		@round_up.round_up_times.each do |rut|
			@round_up.offices.each do |office|
				match_groups << MatchGroup.new office.id, rut.id
			end
		end
		match_groups
	end
end

=begin
create an object that has the match_time id, the date, the office, and an array for users
create arrays for all round up times by office and time
	

build possible match objects based on time/office
for each user - if not matched this week 
	go through each round_up_time by office
		get the score for that user
	the round_up_time with the lowest score (greater than 0)
	for each user in that lowest scoring time/office
		find the one with the fewest opportunities to match someone that week



week
	round_up_time_by_office
		users
			past meetings
			find all possible people to match the user with (not in past meeting, and )
			(the fewer possible matches, the higher priority matching that user should be)


users
	get all their round up times by office


get all round_up_times
get dates for each round up time for this/coming week

get all users
get all round_up_user_availabilities
for each  

#test plan


=end
