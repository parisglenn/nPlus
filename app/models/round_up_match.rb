class RoundUpMatch < ActiveRecord::Base
  attr_accessible :date, :expires, :location, :round_up_time_id

  has_many :users, through: :round_up_match_users
  belongs_to :round_up_time

  acts_as_commentable
end
