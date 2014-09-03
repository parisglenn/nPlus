# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Interest.create!(:name => "Sports")
# Interest.create!(:name => "Entertainment")
# Interest.create!(:name => "Music")
# Interest.create!(:name => "Technology")
# Interest.create!(:name => "Marketing")
# Interest.create!(:name => "Charity")

# Team.create!(:name => "Global Business Solutions")
# Team.create!(:name => "Engineering")
# Team.create!(:name => "Client Services")
# Team.create!(:name => "Sales")
# Team.create!(:name => "Marketing")
# Team.create!(:name => "Finance")
# Team.create!(:name => "Support")



# gzna=Geo.create!({
# 	name: "North America",
# 	location_type: "global_zone"
# 	})
# gcus=Geo.create!({
# 	name: "United States",
# 	location_type: "country",
# 	parent_zone: gzna.id
# 	})
# greus=Geo.create!({
# 	name: "US East",
# 	location_type: "region",
# 	parent_country: gcus.id
# 	})
# gcny=Geo.create!({
# 	name: "New York",
# 	location_type: "city",
# 	parent_region: greus.id
# 	})
# gobw=Geo.create!({
# 	name: "1440 Broadway - NY",
# 	location_type: "office",
# 	parent_city: gcny.id
# 	})
# gomd=Geo.create!({
# 	name: "Madison Ave - NY",
# 	location_type: "office",
# 	parent_city: gcny.id
# 	})
# goaa=Geo.create!({
# 	name: "Avenue of the Americas - NY",
# 	location_type: "office",
# 	parent_city: gcny.id
# 	})
# gcbm=Geo.create!({
# 	name: "Boston",
# 	location_type: "city",
# 	parent_region: greus.id
# 	})
# gocm=Geo.create!({
# 	name: "Cambridge",
# 	location_type: "office",
# 	parent_city: gcbm.id
# 	})
# grmus=Geo.create!({
# 	name: "US Midwest",
# 	location_type: "region",
# 	parent_country: gcus.id
# 	})
# gcci=Geo.create!({
# 	name: "Chicago",
# 	location_type: "city",
# 	parent_region: grmus.id
# 	})
# goci=Geo.create!({
# 	name: "Chicago Office",
# 	location_type: "office",
# 	parent_city: gcci.id
# 	})
# grwus=Geo.create!({
# 	name: "US West",
# 	location_type: "region",
# 	parent_country: gcus.id
# 	})
# gcsf=Geo.create({
# 	name: "San Francisco",
# 	location_type: "city",
# 	parent_region: grwus.id
# 	})
# gosf=Geo.create!({
# 	name: "San Francisco Office",
# 	location_type: "office",
# 	parent_city: gcsf.id
# 	})
# grsus=Geo.create!({
# 	name: "US South",
# 	location_type: "region",
# 	parent_country: gcus.id
# 	})
# gcmf=Geo.create({
# 	name: "Miami",
# 	location_type: "city",
# 	parent_region: grsus.id
# 	})
# gomf=Geo.create!({
# 	name: "Miami Office",
# 	location_type: "office",
# 	parent_city: gcmf.id
# 	})
# gzsa=Geo.create!({
# 	name: "South America",
# 	location_type: "global_zone"
# 	})
# gcbr=Geo.create!({
# 	name: "Brazil",
# 	location_type: "country",
# 	parent_zone: gzsa.id
# 	})
# grbr=Geo.create!({
# 	name: "Brazil",
# 	location_type: "region",
# 	parent_country: gcbr.id
# 	})
# gcspb=Geo.create!({
# 	name: "Sao Paulo",
# 	location_type: "city",
# 	parent_region: grbr.id
# 	})
# gospb=Geo.create!({
# 	name: "Sao Paulo Office",
# 	location_type: "office",
# 	parent_city: gcspb.id
# 	})
# gzemea=Geo.create!({
# 	name: "EMEA",
# 	location_type: "global_zone"
# 	})
# gcuk=Geo.create!({
# 	name: "United Kingdom",
# 	location_type: "country",
# 	parent_zone: gzemea.id
# 	})
# gren=Geo.create!({
# 	name: "England",
# 	location_type: "region",
# 	parent_country: gcuk.id
# 	})
# gcluk=Geo.create!({
# 	name: "London",
# 	location_type: "city",
# 	parent_region: gren.id
# 	})
# goluk=Geo.create!({
# 	name: "London Office",
# 	location_type: "office",
# 	parent_city: gcluk.id
# 	})
# gzapac=Geo.create!({
# 	name: "APAC",
# 	location_type: "global_zone"
# 	})
# gcjp=Geo.create!({
# 	name: "Japan",
# 	location_type: "country",
# 	parent_zone: gzapac.id
# 	})
# grjp=Geo.create!({
# 	name: "Japan",
# 	location_type: "region",
# 	parent_country: gcjp.id
# 	})
# gctk=Geo.create!({
# 	name: "Tokyo",
# 	location_type: "city",
# 	parent_region: grjp.id
# 	})
# gotk=Geo.create!({
# 	name: "Tokyo Office",
# 	location_type: "office",
# 	parent_city: gctk.id
# 	})

###<RoundUpTime id: 1, day: "Monday", start_hour: 1500, end_hour: 1600, deprecated: false, created_at: "2014-05-23 12:58:27", updated_at: "2014-05-23 12:58:27">, 
###<RoundUpTime id: 2, day: "Tuesday", start_hour: 1000, end_hour: 1100, deprecated: false, created_at: "2014-05-23 12:58:55", updated_at: "2014-05-23 12:58:55">] 

# RoundUpTime.create!({
# 	day: "Monday",
# 	start_hour: 1500,
# 	end_hour: 1600,
# 	deprecated: false
# 	})
# RoundUpTime.create!({
# 	day: "Tuesday",
# 	start_hour: 1000,
# 	end_hour: 1100,
# 	deprecated: false
# 	})
# RoundUpTime.create!({
# 	day: "Wednesday",
# 	start_hour: 1200,
# 	end_hour: 1300,
# 	deprecated: false
# 	})
# RoundUpTime.create!({
# 	day: "Thursday",
# 	start_hour: 1400,
# 	end_hour: 1500,
# 	deprecated: false
# 	})
# RoundUpTime.create!({
# 	day: "Friday",
# 	start_hour: 1100,
# 	end_hour: 1200,
# 	deprecated: false
# 	})


###Round up testing

# u1=User.create!({
# 	first_name: "user1",
# 	email: "user1@nplus.com",
# 	password: "password"
# 	})

# u2=User.create!({
# 	first_name: "user2",
# 	email: "user2@nplus.com",
# 	password: "password"
# 	})

# u3=User.create!({
# 	first_name: "user3",
# 	email: "user3@nplus.com",
# 	password: "password"
# 	})

# u4=User.create!({
# 	first_name: "user4",
# 	email: "user4@nplus.com",
# 	password: "password"
# 	})

# u5=User.create!({
# 	first_name: "user5",
# 	email: "user5@nplus.com",
# 	password: "password"
# 	})
# u6=User.create!({
# 	first_name: "user6",
# 	email: "user6@nplus.com",
# 	password: "password"
# 	})
# #Round up user availabilities
# #geos 53, 54, 55
# #round up time 3, 4, 5, 6, 7
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 3,
# 	user_id: u1.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 3,
# 	user_id: u2.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 6,
# 	user_id: u2.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 3,
# 	user_id: u3.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 4,
# 	user_id: u3.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 5,
# 	user_id: u3.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 4,
# 	user_id: u4.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 5,
# 	user_id: u4.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 6,
# 	user_id: u4.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 7,
# 	user_id: u4.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 53,
# 	round_up_time_id: 5,
# 	user_id: u5.id
# 	})
# RoundUpUserAvailability.create!({
# 	geo_id: 54,
# 	round_up_time_id: 5,
# 	user_id: u6.id
# 	})
=begin

test plan
	user1 - 1 total availabilities (monday) 3 possible matches
	user2 - 2 total availabilities (monday, thursday) 4 possible matches
	user3 - 3 total availabilities (monday, tuesday, wednesday) 6 possible matches

	user4 - 4 total availabilities (tuesday, wednesday, thursday, friday) - friday should not show up 4 possible matches
	user5 - 1 total availability (wednesday) 2 possible matches
	user 6 - 1 availabiltity (monday - other office) 0 possible matches

user1 should get matched wth user2 (but not three has lots of total availabilities)

1 and 2 were matched - 4 and 5 were matched 
6 can't match with anyone, so 3 was left out
5 matched with 4 and not 3 because three has more matches in monday, etc

5 should always match with 4 over 3, if possible
######################   test past matches - working but i have no idea why it wasnt before
give user 4 a past match with 5
3 should then match with 5

######################   test pending matches - works
give user 4 a pending match with 6 (is pending)
3 should then match with 5

######################   test pending matches - works (currently 4-5 and 1-2 match)
give user 4 a pending match with 6 (has declined)
4 should then match with 5

######################   test decline matches - works
give user 4 a declined match with 6 (is pending)
4 should then match with 5

######################   test decline matches
give user 4 a declined match with 6 (has declined)
4 should then match with 5

######################   test expired matches
give user 4 an expired match (no rsvp) with 6 (no rsvp)
4 should match with 5

=end
#test running the algo with existing and past matches existing as well

#rum = RoundUpMatch.create({date: pair.availability.date, expires: @today + 1.days, round_up_time_id: pair.availability.round_up_time.id}) #:date, :expires, :location, :round_up_time_id

rum = RoundUpMatch.create!({
	round_up_time_id: 3,
	date: Date.today + 2.days,
	expires: 1.days.from_now
	})

RoundUpMatchUser.create!({
	round_up_match_id: rum.id,
	user_id: 1
	})

RoundUpMatchUser.create!({
	round_up_match_id: rum.id,
	user_id: 2
	})
