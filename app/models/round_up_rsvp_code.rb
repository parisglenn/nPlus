class RoundUpRsvpCode < ActiveRecord::Base
  attr_accessible :action, :code, :round_up_match_id, :user_id

  belongs_to :user
  belongs_to :round_up_match
end
