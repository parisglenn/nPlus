class RoundUpMatchUser < ActiveRecord::Base
  attr_accessible :open, :round_up_match_id, :rsvp, :user_id

  belongs_to :user 
  belongs_to :round_up_match

  def self.get_user_matches user_id
  	self.where(user_id: user_id).where("rsvp != 'declined'")
  end

  def self.get_rsvp user_id, round_up_match_id
  	self.where(user_id: user_id).where(round_up_match_id: round_up_match_id).first
  end

end
