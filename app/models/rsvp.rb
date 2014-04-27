class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :host, :status, :user_id, :event_id
end