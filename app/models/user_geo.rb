class UserGeo < ActiveRecord::Base
  attr_accessible :geo_id, :subscribed, :user_id
  belongs_to :geo
  belongs_to :user
end
