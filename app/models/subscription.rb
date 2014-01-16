class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :geo
  belongs_to :interest
  # attr_accessible :title, :body
end
