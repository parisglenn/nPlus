# TO DO
# figure out what date the meeting is (include the hour from the rut as well - full date time)


#array.sample will choose random element
#get kv pair from has that has the lowest value

class GenerateMatches
	def initialize
		@round_up = RoundUp.new
		@match_groups = get_match_groups
		@pair_expiration_date = Time.now + 1.days
		@meeting_dates = get_meeting_dates
		group_users #put users in match_groups
		find_previous_matches #all matchUsers have an array of users they've met with
		potential_user_matches #each users availability has a list of all user ids it could match with
		best_pairing = get_best_pairing
		commit_pairs_to_db best_pairing
		#working on pair_users - sort them by total_possible_matches
	end

	def commit_pairs_to_db best_pairing
		best_pairing.each do |pair, avail|
			rum = RoundUpMatch.new date: @meeting_date[avail.id], expires: @pair_expiration_date, round_up_time_id: avail.id
			RoundUpMatchUser.new user_id: pair[0], round_up_match_id: rum.id
			RoundUpMatchUser.new user_id: pair[1], round_up_match_id: rum.id
		end
	end

	def get_meeting_dates avail_id
		today_wday = Today.now.wday
		meeting_dates = {}
		@round_up.round_up_times.each do |rut|
			meeting_dates[rut.id] = get_next_date rut, today_wday
		end
		meeting_dates
	end

	def get_next_date rut, today_wday
		rut_wday = case rut.day
		when "Sunday" 
			0
		when "Monday"
			1
		when "Tuesday"
			2
		when "Wednesday"
			3
		when "Thursday"
			4
		when "Friday"
			5
		when "Saturday"
			6
		end

		if today_wday > rut_wday
			add_days = 7 - today_wday - rut_wday
		else
			add_days = rut_wday - today_wday
		end
		Time.now + add_day.days # incorporate rut.start_hour 
	end

	def get_best_pairing
		count = 0
		matched = false
		random = false
		best_pairing = [] 
		while not matched and count < 10
			if count > 0
				random = true
			end
			bp = BestPairings.new @round_up, @match_groups, random
			pairings = bp.pairings
			if pairings.length == @round_up.users.length/2
				best_pairing = pairings
				matched = true
				#just use break instead of matched flag?
			elsif pairings.length > best_pairing.length
				best_pairing = pairings
			end
			count += 1
		end
		best_pairing
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

	def group_users
		@round_up.users.each do |u|
			user = MatchUser.new u
			user_avails = get_user_avails user
			user_avails.each do |ua|
				@match_groups.each do |mg|
					if mg.office_id == ua.geo_id and mg.round_up_time_id == ua.round_up_time_id
						mg.users << user 
						user.availabilities[mg] = []
						break
					end
				end
			end
		end
	end

	def find_previous_matches
		@round_up.users.each do |user|
			user.get_previous_matches @round_up
		end
	end

	def potential_user_matches
		#double check all logic in method
		@round_up.users.each do |user|
			least_available = 9999999999 #a number that will always be higher than the first availability
			user.availabilities.each do |k, v|
				available = 0 
				@round_up.users.each do |u|
					u.availabilities.each do |mk, mv|
						if not user.previous_matches.include? u.id and k.office_id == mk.office_id and k.round_up_time_id == mk.round_up_time_id
							v << u.id
							available += 1
							user.total_possible_matches += 1

							break
						end
					end
				end
				if available != 0 and available < least_available
					user.smallest_availability = k
				end
			end
		end
	end

	def get_user_avails user
		user_avails = []
		@round_up.user_availabilities.each do |avail|
			if avail.user_id == user.id
				user_avails << avail
			end
		end
		user_avails
	end
end

class RoundUp
	def initialize
		@offices = Office.all
		@round_up_times = RoundUpTime.all
		@users = User.all #just users who are participating and who are not already booked this week
		#@past_matches = RoundUpMatch.all #I don't think this table will have any useful info
		@user_matches = RoundUpMatchUser.all
		@user_availabilities = RoundUpUserAvailability.all
	end

end

class BestPairings
	def initialize round_up, match_groups, random
		@round_up = round_up
		@match_groups = match_groups
		@random = random
		@unmatched_users = sort_array @round_up.users, :total_possible_matches #ordered by least available users
		@matched_users = get_matched_users #one dimensional array
		@pairings = {} # or hash where value is availability, and key is array of two users
		pair_users #add matches to priovious matches so that in the next loop i won't try to pair with them? - or just use randomness to find the best match

	end

	def sort_array list, arg
		#returns array sorted from largest to smallest - good for popping off the smallest
		small_to_large = list.sort { |a,b| a.send(:arg) <=> b.send(:arg) } #what happens if i switch a/b - will that reverse sort?
		small_to_large.reverse
	end

	def get_matched_users
		#get saturday's date
		add_days = 6 - Today.now.wday
		rums = RoundUpMatch.where("date > #{Date.today}").where("date < #{Date.today + add_days.days}")
		rum_ids = rums.map{ |r| r.id }
		users = RoundUpMatchUser.where round_up_match_id: rum_ids
		user_ids = users.map{ |u| u.id }
		User.where id: user_ids
	end

	def pair_users
		#don't remove users from unmatched users - put them in matched users and check to make sure users arn't in matched users
		while @unmatched_users.length > 1
			user = @unmatched_users.pop
			user.availabilities.each do |key, value|
				if @random
					random_choice_user = value.sample
					if not @matched_users.include? user and not @matched_users.include? random_choice_user
						@pairings << [user, random_choice_user]
						@matched_users << user
						@matched_users << random_choice_user
						break
					end					
				else
					least_available_users = sort_array value, :total_possible_matches
					least_available_user = least_available_users.pop
				if not @matched_users.include? user and not @matched_users.include? least_available_user
					@pairings[[user, least_available_user]] = key 
					@matched_users << user
					@matched_users << least_available_user
					break
				end
			end
		end
	end

end

class MatchUser
	def initialize user
		@db_user = user
		@id = user.id
		@matched_this_week = false
		@availabilities = {}
		@previous_matches = []
		@smallest_availability = nil
		@total_possible_matches = 0
	end

	def get_previous_matches round_up
		match_events = []
		round_up.user_matches.each do |um|
			if um.user_id == self.id
				match_events << um.id
			end
		end
		round_up.user_matches.each do |um|
			if match_events.include? um.id and um.user_id != self.id
				self.previous_matches << um.user_id
			end
		end
	end
end

class MatchGroup
	def initialize office_id, round_up_time_id
		@office_id = office_id
		@round_up_time_id = round_up_time_id
		@date = get_date
		@users = []
	end
end



=begin
create an object that has the match_time id, the date, the office, and an array for users
for each user - for each group - figure out how many potential matches they have

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

Monday
	user1 - 1 total availabilities (monday)
	user2 - 2 total availabilities (monday, thursday)
	user3 - 3 total availabilities (monday, tuesday, wednesday)

	user4 - 4 total availabilities (tuesday, wednesday, thursday, friday)
	user5 - 1 total availability (wednesday)

user1 should get matched wth user2 (but not three has lots of total availabilities)


=end

# class Pair
# 	def initialize
# 		@user_1
# 		@user_2
# 		@round_up_time_id
# 		@date 
# 	end
# end