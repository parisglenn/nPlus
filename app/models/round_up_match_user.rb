class RoundUpMatchUser < ActiveRecord::Base
  attr_accessible :open, :round_up_match_id, :rsvp, :user_id

  belongs_to :user 
  belongs_to :round_up_match
end
