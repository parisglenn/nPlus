class RoundUpUserAvailability < ActiveRecord::Base
  attr_accessible :geo_id, :round_up_time_id, :user_id
  belongs_to :user
  belongs_to :geo
  belongs_to :round_up_time
end
