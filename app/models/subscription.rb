class Subscription < ActiveRecord::Base
  belongs_to :user
  has_one :geo
  has_one :interest
  attr_accessible :user_id, :geo_id, :time_id, :interest_id
 
end
