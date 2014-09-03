class RoundUpTime < ActiveRecord::Base
  attr_accessible :day, :deprecated, :end_hour, :start_hour
  has_many :round_up_user_availabilities
  has_many :round_up_matches

end
