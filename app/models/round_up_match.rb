class RoundUpMatch < ActiveRecord::Base
  attr_accessible :date, :expires, :location, :round_up_time_id, :geo_id, :open

  has_many :users, through: :round_up_match_users
  has_many :round_up_rsvp_codes
  belongs_to :round_up_time
  belongs_to :geo

  acts_as_commentable

  def self.get_next_match user_id
  	# this includes pending matches
  	all_matches = RoundUpMatchUser.get_user_matches user_id #where my rsvp is not declined
  	match_ids = all_matches.map(&:round_up_match_id)
  	next_match = self.where(id: match_ids).
  	# where("date >= ?" ,Date.today.strftime("%Y-%m-%d")).
  	# where("expires > ?", Time.now.strftime("%Y-%m-%d %H:%M:%S")).first
  	where("date >= \'#{Date.today.strftime("%Y-%m-%d")}\'").
  	where("expires > \'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}\'").first
  	if next_match.nil?
  		return nil
  	else
	  	other_match_user = next_match.get_other_user user_id
	  	if other_match_user and other_match_user.rsvp != 'declined'
	  		return next_match
	  	else 
	  		return nil
	  	end
	end
  end

  def self.previous_match_this_week user_id 
  	#if the match already happened, I don't care about when it expired, only about rsvps
  	#pending matches are in the future - expired matches don't count as a match this week
  	all_matches = RoundUpMatchUser.get_user_matches user_id #where my rsvp is not declined
  	match_ids = all_matches.select{ |am| am.rsvp == 'attending'}.map(&:round_up_match_id)
  	matches_this_week = self.where(id: match_ids).
  	#where("date >= ?", (Date.today.wday).days.ago.strftime("%Y-%m-%d"))
  	where("date >= \'#{(Date.today.wday).days.ago.strftime("%Y-%m-%d")}\'").
  	where("date <= \'#{(7 - Date.today.wday).days.from_now.strftime("%Y-%m-%d")}\'")
  	matches_this_week.each do |match|
  		other_match_user = match.get_other_user user_id
	  	if other_match_user and other_match_user.rsvp == 'attending'
	  		return match
	  	end
  	end	
  	nil
  end

  def get_users
  	RoundUpMatchUser.where(round_up_match_id: self.id)
  end

  def get_other_user user_id #this is assuming two users even though more can have it
  	self.get_users.detect { |u| u.user_id != user_id }
  end
end
