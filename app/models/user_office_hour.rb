class UserOfficeHour < ActiveRecord::Base
  attr_accessible :day_of_week, :ends_at, :geo_id, :starts_at, :user_id

  belongs_to :user
  belongs_to :geo
end
