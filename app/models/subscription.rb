class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :geo
  belongs_to :interest
  
  accepts_nested_attributes_for :user_attributes, :geo_attributes, :interest_attributes
  
  attr_accessible :user_id, :geo_id, :interest_id
end
