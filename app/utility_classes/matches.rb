#glossary
	# round up time = the time of week the user has selected as being available every week
	# availability = a particular time in the (coming) week that the user is available
		# availabilities contain lists of users that can be matched during that time

		#get all office geos
		#create matchAvailabilities
			# will have round up time id - this is how users will match to it
			#i need office geos as well
	# rsvp status -- currently using 'attending' in MatchUser#get_past_matches
#generate_matches
	#have an attribute that tracks if i've tried to match all new pairs - then try to match people again
	#procedure
		# instantiate blank object
		# get all users - 
		# set all users - class method in matchUser class and matchAvailabilities class
		# get all offices
		# set all offices - class method under matchAvailabilities
		# get all round up times - will be used to create match availabilities with offices
		# set all round up times - in match availabilities class method 
		# get all round up user availabilities
		# set all round up user availabilities as set round up times in user class method
		# create match availabities objects - by office/by time of week - using round up times
			# as each one is created, add it to a class variable that is an array of all match availabilities
			#function to count all unmatched users	
		# get past matches
		# create new user objects - 
			# set past matches
			# set their matchAvailabilities by using class method of user round up availabilities and all MatchAvailabilities
				# add the user to the match availabitity as the match availabity is added to the user  ## duplicate note?: i probably want to put matchroundup times in users, then add the user to the round up time as i do that, then its all done in one swoop


		#put users in availabilities
			#for each availability, loop through each one, nested loop through each user and add as necissary
			#have a function to get the count of how many unmatched users the availability has
		#remove availabilities with 0 users
		#put availabities in users
			#just an array of new availabilities objects? - this will already have all the users
			#have a function to get the count of total possible matches the user has across availabilities
		#generate matches
			#start with availability that has fewest users
				#find unmatched user with fewest available matches
				#match that user to unmatched user with fewest available matches that they haven't been matched with yet
					#mark both users as matched
					#generate new match object
		#get dates for matches
		#commit matches to DB	
	#what class methods do I want?	

class RoundUp # have one class query the database - have another class generate matches - 
		# this way i only have to set everything up once (query db - set past users) - 
		# then user instances of another class to generate matches and I can see which is best
	attr_accessor :db, :match_availabilities, :today, :results
	def initialize
		@results = []
		@match_availabilities = []
		@today = Time.now
		@db = QueryDatabase.new
		@db.query_db
		get_match_availabilities
		@db.users.each do |u|
			u.set_past_matches @db.past_matches
			u.set_round_up_times @db.user_availabilities, @db.round_up_times
		end	
		get_user_availabilities
		#everything above this line will be run once - then do several generate matches
	end

	def run
		
		#so maybe everything above in the run method for now should actually be in initialize
		(1..1).each do |result|
			@gm = GenerateMatches.new self
			@results << @gm
			@gm.pair_users
		end
	end

	def get_user_availabilities
		@db.users.each do |u|
			@match_availabilities.each do |ma|
				if u.round_up_time_ids.include? ma.round_up_time.id
					ma.users << u
					u.availabilities << ma
				end
			end
		end
	end

	def get_match_availabilities
		@db.offices.each do |office|
			@db.round_up_times.each |rut| do
				@match_availabilities << MatchAvailabilities.new rut, office, @today
			end
		end
	end
end

class GenerateMatches
	attr_accessor :round_up, :pairs
	def initialize round_up
		@round_up = round_up
		@pairs = []
	end

	def pair_users
		@sorted_users = sort_array @round_up.db.users, :total_possible_matches
		while @sorted_users.count > 1
			u = @sorted_users.pop
			sorted_avails = sort_array u.availabilities, :matched_users_count
			while sorted_avails.count > 0 and not u.matched?
				avail = sorted_avails.pop
				sorted_users = sort_array avail.users, :total_possible_matches
				while sorted_users.count > 0 and not u.matched?
					pos_match = sorted_users.pop
					if not pos_match.matched? and pos_match.db_user.id != u.db_user.id
						MatchPair.new pos_match, u, avail
					end
				end
			end
		end
	end

	def sort_array list, arg #large_to_small
		#returns array sorted from largest to smallest - good for popping off the smallest
		small_to_large = list.sort { |a,b| a.send(arg) <=> b.send(arg) } #what happens if i switch a/b - will that reverse sort?
		small_to_large.reverse
	end
	end
end

class MatchPair
	def initialize user1, user2, availability

	end
end

class QueryDatabase
	#maybe this class should just hold all the tables, and the class methods don't get assigned
	attr_accessor :users, :round_up_times, :user_availabilities, :offices, :past_matches
	def initialize
	end

	def query_db
		# pull from the DB tables that may be used by multiple classes
		query_all_users
		query_all_user_availabilities
		query_all_round_up_times
		query_all_offices
		query_all_past_matches
	end

	def query_all_users
		@users = User.includes(:round_up_user_availabilities).
			joins(:round_up_user_availabilities).map { |u| MatchUser.new u }
	end

	def query_all_round_up_times
		@round_up_times = RoundUpTime.all
	end

	def query_all_user_availabilities
		@user_availabilities = RoundUpUserAvailabilty.all
	end

	def query_all_offices
		@offices = Geo.where('parent_city is not null')
	end

	def query_all_past_matches
		@past_matches = RoundUpMatchUser.all
	end

end

class MatchUser 
	attr_accessor :db_user, :matched, :round_up_time_ids, :availabilities, :past_matches
	
	def initialize user
		@db_user = user
		@matched = false
		@round_up_time_ids = []
		@availabilities = []
		@past_matches = []
	end

	def matched?
		matched
	end

	def total_possible_matches
		count = 0
		@availabilities.each do |a|
			a.users.each do |u|
				unless u.matched?
					count += 1
				end
			end
		end	
	end

	def set_past_matches all_past_matches
		#find all my past matches
		my_matches = all_past_matches.select( |pm| { 
			pm.user_id == @db_user.id }).
			map |pm2| { pm2.round_up_match_id } 
		end
		#find users also assigned to that past match
		@past_matches = all_past_matches.select( |pm| {
			my_maches.include? pm.round_up_match_id and pm.user_id != @db_user.id and pm.rsvp == 'attending'
			}).
			map |pm2| { pm2.user_id }
		end
	end

	def set_round_up_time_ids round_up_times
		#user availabilities should be included in user object, test in console to be sure
		@round_up_time_ids = @db_user.round_up_user_availabilities.
			map { |ruua| ruua.round_up_time_id }
	end
end

class MatchAvailability
	attr_accessor :round_up_time, :office, :users, :date

	def initialize round_up_time, office, today
		@round_up_time = round_up_time
		@office = office
		@users = []
		@date = get_next_date round_up_time, today.wday
	end

	def matched_users_count
		@users.select{ |u| u.matched }.count
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
		Time.now + add_days.days # incorporate rut.start_hour 
	end

end



#get users
#create new user object
	#matched - true/false
	#availabilities - set availabilities
	#get_num_availabilities - counts how many availabilities are not matched - for each availabilitiy or for all availabilities
	#previous matches - get previous matches - is it necissary to add current match to previous matches? probably not



#what happens when a user is added as a potential match


#what happens when a user is selected as a match
	#it's matched value is set to true

	### was in RoundUp class
	# def set_class_variables
	# 	# set class variables containing info from various tables
	# 	MatchUser.set_all_users @gm.users
	# 	MatchUser.set_all_user_availabilities @gm.user_availabilities
	# 	MatchUser.set_all_past_matches
	# 	MatchAvailability.set_all_offices
	# 	MatchAvailability.set_all_round_up_times @gm.round_up_times
	# end

	### were in MatchUser
	# def self.set_all_users users
	# 	@@all_users = users
	# end

	# def self.all_users
	# 	@@all_users
	# end

	# def self.set_all_round_up_times round_up_times
	# 	@@round_up_times = round_up_times
	# end

	# def self.round_up_times
	# 	@@round_up_times
	# end

	# def self.set_all_past_matches
	# 	all_past_matches = RoundUpMatch.all
	# end

	# def past_matches
	# 	@@all_past_matches
	# end 

	### were in MatchAvailabilities
	# def self.set_all_offices
	# 	@@all_offices = Office.all
	# end

	# def self.all_offices
	# 	@@all_offices
	# end

#notes
	#count how many objects in an array have a certain attribute set to true, like using select, but then counting that
	#once I've tried to match everyone with someone new, try to match every left with someone