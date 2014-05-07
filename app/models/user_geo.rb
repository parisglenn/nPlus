class UserGeo < ActiveRecord::Base
  attr_accessible :geo_id, :subscribed, :user_id
end
