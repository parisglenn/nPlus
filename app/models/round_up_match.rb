class RoundUpMatch < ActiveRecord::Base
  attr_accessible :date, :expires, :location, :round_up_time_id, :geo_id, :open

  has_many :users, through: :round_up_match_users
  belongs_to :round_up_time
  belongs_to :geo

  acts_as_commentable

  def self.get_next_match user_id
  	all_matches = RoundUpMatchUser.get_user_matches user_id #where rsvp is not declined
  	match_ids = all_matches.map(&:round_up_match_id)
  	next_match = self.where(id: match_ids).where("date >= #{Date.today.strftime("%Y-%m-%d")}").
  	where("expires > ?", Time.now.strftime("%Y-%m-%d %H:%M:%S")).first
  	match_users = next_match.get_users
  	other_match_user = match_users.detect { |u| u.user.id != user_id }
  	#other_match_user = RoundUpMatchUser.get_rsvp other_user_id, next_match.id
  	#binding.pry
  	if other_match_user and other_match_user.rsvp != 'declined'
  		return next_match
  	else 
  		return nil
  	end
  end

  def get_users
  	RoundUpMatchUser.where(round_up_match_id: self.id)
  end

  def get_other_user user_id
  	self.get_users.detect { |u| u.user_id != user_id }
  end
end
