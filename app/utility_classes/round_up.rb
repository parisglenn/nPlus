class RoundUp
	def initialize

	end

end

class MatchUser
	def initialize
		@matched_this_week = false
		@availabilities = []#[day_of_week][office]
	end
end

=begin
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
