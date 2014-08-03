class RoundUpMatch < ActiveRecord::Base
  attr_accessible :date, :expires, :location, :round_up_time_id, :geo_id, :open

  has_many :users, through: :round_up_match_users
  belongs_to :round_up_time
  belongs_to :geo

  acts_as_commentable

  def self.get_next_match user_id
  	all_matches = RoundUpMatchUser.get_user_matches user_id #where rsvp is not declined
  	match_ids = all_matches.map(&:round_up_match_id)
  	self.where(id: match_ids).where("date > #{Date.today.strftime}").first
  end

  def get_users
  	RoundUpMatchUser.where(round_up_match_id: self.id)
  end

  def get_other_user user_id
  	self.get_users.detect { |u| u.user_id != user_id }
  end
end
