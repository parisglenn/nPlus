#TO DO 7-30-14 - work on MatchUser current RSVPs - currenlty called set_declined_round_ups
	#all users should have pending_matches, declined_matches, and if matched this week, just set as matched=true
class RoundUp # have one class query the database - have another class generate matches - 
		# this way i only have to set everything up once (query db - set past users) - 
		# then user instances of another class to generate matches and I can see which is best
	attr_accessor :db, :match_availabilities, :today, :results, :gm
	def initialize
		@results = []
		@match_availabilities = []
		@today = Time.now
		@db = QueryDatabase.new
		@db.query_db @today
		get_match_availabilities
		@db.users.each do |u|
			u.set_past_matches @db.past_matches
			u.set_round_up_time_ids @db.round_up_times #This maybe isn't being used. don't include any that have been declined this week
			# extend round up user availabilities to include offices of parent cities that were selected
		end	
		get_user_availabilities # add users with city preferences to child offices
		remove_empty_match_availabilities
		return true
	end

	def run
		# take all unmatched users - get rid of their past matches and try to pair the remaining users
		(1..1).each do |result|
			@gm = GenerateMatches.new self
			@results << @gm
			@gm.pair_users
		end 
	end

	def select_best_matches #do this later
		#pick which gm strategy produced the most matches

		#commit_pairs @results[0].pairs #eventually uncomment
	end

	def get_user_availabilities
		# add users with city preferences to child offices
		@db.users.each do |u|
			u.availabilities.each do |ruaa| 
				@match_availabilities.each do |ma|
					#binding.pry
					if ruaa.round_up_time_id == ma.round_up_time.id and ruaa.geo_id == ma.office.id
						ma.users << u.id
						u.availability_ids << ma.id#.round_up_time.id.to_s + "---" + ma.office.id.to_s
					end
				end
			end
		end
		return true
	end

	def remove_empty_match_availabilities
		empty_match_availability_ids = []
		all_match_availabilitiies = @match_availabilities.dup
		@match_availabilities = all_match_availabilitiies.each do |ma|
			if ma.users.count > 1
				@match_availabilities << ma
			else
				empty_match_availability_ids << ma.id
			end
		end
		@db.users.each do |u|
			empty_match_availability_ids.each do |ema|
				u.availability_ids.delete ema
			end
		end
	end

	def get_match_availabilities
		@db.offices.each do |office|
			@db.round_up_times.each do |rut|
				@match_availabilities << MatchAvailability.new(rut, office, @today)
			end
		end
	end

	def commit_pairs pairs
		pairs.each do |pair|
			rum = RoundUpMatch.create({date: pair.availability.date, expires: @today + 1.days, round_up_time_id: pair.availability.round_up_time.id, geo_id: pair.availability.office.id}) #:date, :expires, :location, :round_up_time_id
			RoundUpMatchUser.create({user_id: pair.user1.id, round_up_match_id: rum.id}) #:open, :round_up_match_id, :rsvp, :user_id
			RoundUpMatchUser.create({user_id: pair.user2.id, round_up_match_id: rum.id})
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
		# the loop ends ASAP as they stop when the user gets matched
		@sorted_users = sort_array @round_up.db.users, :total_possible_matches
		while @sorted_users.count > 1
			u = @sorted_users.pop
			sorted_avails = sort_array u.get_round_up_match_availabilities, :matched_users_count
			while sorted_avails.count > 0 and not u.matched
				avail = sorted_avails.pop
				sorted_users = sort_array avail.get_users, :total_possible_matches
				while sorted_users.count > 0 and not u.matched
					pos_match = sorted_users.pop
					if users_pair? u, pos_match, avail
						@pairs << MatchPair.new(pos_match, u, avail)
						pos_match.matched = true
						u.matched = true
					end
				end
			end
		end
	end

	def users_pair? user1, user2, avail #add additional filters here
		(	not user2.matched and 
			not user1.matched and
			user2.id != user1.id and
			not user1.past_matches.include? user2.id and 
			not user2.past_matches.include? user1.id and
			not user1.declined_round_ups.include? avail.round_up_time.id and
			not user1.declined_round_ups.include? avail.round_up_time.id
		)
	end

	def sort_array list, arg #large_to_small
		#returns array sorted from largest to smallest - good for popping off the smallest
		small_to_large = list.sort { |a,b| a.send(arg) <=> b.send(arg) } #what happens if i switch a/b - will that reverse sort?
		small_to_large.reverse
	end

end

class MatchPair
	attr_accessor :user1, :user2, :availability
	def initialize user1, user2, availability
		@user1 = user1
		@user2 = user2
		@availability = availability
	end
end

class QueryDatabase
	#maybe this class should just hold all the tables, and the class methods don't get assigned
	attr_accessor :users, :round_up_times, :user_availabilities, :offices, :past_matches, :geos
	def initialize
	end

	def query_db today
		# pull from the DB tables that may be used by multiple classes
		MatchUser.set_declined_round_ups today
		query_all_geos
		MatchUser.set_geos @geos
		query_all_users
		query_all_round_up_times
		query_all_offices
		query_all_past_matches
		
	end

	def query_all_users
		## TO DO - only select users who do not have pending or positive RSVPs
		users = User.includes(:round_up_user_availabilities).#, :round_up_matches).
			joins(:round_up_user_availabilities)#, :round_up_matches).
		@users = users.map { |u| MatchUser.new u }
	end

	def query_all_round_up_times
		@round_up_times = RoundUpTime.all
	end

	def query_all_offices
		@offices = Geo.where('parent_city is not null')
	end

	def query_all_past_matches
		@past_matches = RoundUpMatchUser.all
	end

	def query_all_geos
		@geos = Geo.all
	end

end

class MatchUser 
	attr_accessor :db_user, :matched, :round_up_time_ids, :availabilities, :past_matches, 
	:id, :declined_round_ups, :availability_ids
	
	@@all_users = []
	@@all_declined_round_ups = {}
	@@past_limit = nil
	@@geos = {}

	def self.set_geos db_geos
		db_geos.each do |dbg|
			@@geos[dbg.id] = dbg
		end
	end

	def self.set_declined_round_ups today #call this set current RSVPs
		# {user_id => [rut_id1, rut_id2]}	
		rut = RoundUpTime.new day: 'Sunday'
		office = Geo.new name: 'place_holder'
		ma = MatchAvailability.new rut, office, today
		future_limit = ma.get_next_date rut, today.wday
		@@past_limit = future_limit - 7.days
		rums = RoundUpMatch.where("date < #{future_limit}").where("date > #{@@past_limit}")
		rum_ids = rums.map(&:id)
		rumus = RoundUpMatchUser.where(round_up_match_id: rum_ids).where(rsvp: 'declined')
		rumus.each do |r|
			if @@all_declined_round_ups[r.user_id]
				@@all_declined_round_ups[r.user_id] << r.round_up_match_id
			else
				@@all_declined_round_ups[r.user_id] = [r.round_up_match_id]
			end
		end

	end

	def initialize user
		#have a new variable that's an array that has their availabilities from the db, but also availabilities from children of citys, remove city availabilities?
		@db_user = user
		@id = user.id
		@matched = matched?
		@round_up_time_ids = []
		@availabilities = []
		@availability_ids = []
		get_match_availabilities
		@past_matches = []
		@@all_users << self
		@declined_round_ups = @@all_declined_round_ups[@id] || []
	end

	def matched?
		next_match = RoundUpMatch.get_next_match @id
		match_this_week = RoundUpMatch.previous_match_this_week @id
		if next_match.nil? and match_this_week.nil?
			return false
		else
			return true
		end	
	end

	def self.find id
		@@all_users.detect { |u| u.id == id }
	end

	#

	#this could probably be optimized - I think I need to fix this, @availabilities is not being populated
	def get_match_availabilities
		@db_user.round_up_user_availabilities.each do |ruaa|
			geo = @@geos[ruaa.geo_id]
			case geo.location_type
			when 'city'
				child_offices = Geo.get_child_geos ruaa.geo_id
				child_offices.each do |co|
					new_ruaa = ruaa.dup
					new_ruaa.geo_id = co.id
					@availabilities << new_ruaa
				end
			when 'office'
				@availabilities << ruaa
			end
		end
	end

	def get_round_up_match_availabilities
		@availability_ids.map { |ai| MatchAvailability.find(ai) }
	end

	def total_possible_matches
		count = 0
		@availability_ids.each do |a| 
			MatchAvailability.find(a).get_users.each do |u|
				unless u.matched
					count += 1
				end
			end
		end	
		count
	end

	def set_past_matches all_past_matches
		#find all my past matches
		#my_matches = db_user.round_up_matches.map { |rumu| rumu.id }
		## Slower code below
		my_matches = all_past_matches.select { |pm| 
			pm.user_id == @db_user.id }.
			map { |pm2| pm2.round_up_match_id } 

		#find users also assigned to that past match
		@past_matches = all_past_matches.select { |pm|
			(my_matches.include? pm.round_up_match_id and 
			pm.user_id != @db_user.id and 
			pm.rsvp == 'attending')
			}.
			map { |pm2| pm2.user_id }
	end

	#is this being used?
	def set_round_up_time_ids round_up_times
		#user availabilities should be included in user object, test in console to be sure
		@round_up_time_ids = @db_user.round_up_user_availabilities.
			map { |ruua| ruua.round_up_time_id }
	end
end

class MatchAvailability
	attr_accessor :round_up_time, :office, :users, :date, :id

	@@all_match_availabilitiies = []
	@@id = 0

	def get_id
		@@id += 1
	end

	def initialize round_up_time, office, today
		@round_up_time = round_up_time
		@office = office
		@users = []
		@date = get_next_date round_up_time, today.wday
		@id = get_id
		@@all_match_availabilitiies[self.id] = self
	end

	def self.find id
		@@all_match_availabilitiies[id]
		#@@all_match_availabilitiies.detect { |ma| ma.id == id }
	end

	def get_users
		@users.map { |u| MatchUser.find u }
	end

	def matched_users_count
		get_users.select{ |u| u.matched }.count
	end

	def get_next_date rut, today_wday
		# clean this up to use @round_up_time, not an argument for rut
		# also pass in today, not today_wday - so i can use today at the bottom too
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
		Date.today + add_days.days # incorporate rut.start_hour 
	end

end

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
