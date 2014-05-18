class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :host, :status, :user_id, :event_id

  #valid status is any of attending, declined, maybe

	# scope :find_current_user_events, lambda { |user|
	# 	where(:user_id => user.id).order('created_at DESC')
	# }

end