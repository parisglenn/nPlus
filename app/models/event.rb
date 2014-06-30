class Event < ActiveRecord::Base
  belongs_to :geo
  has_many :event_tags
  has_many :rsvps
  attr_accessible :ends_at, :event_date, :location, :name, :starts_at, :geo, :description
  accepts_nested_attributes_for :event_tags

  acts_as_commentable

  def status=(status)
    @status = status
  end

  def status
    @status
  end

  def hosts_include? user
    user_ids = self.rsvps.map do |rsvp|
      rsvp.user_id
    end
    user_ids.include? user.id
  end

  def attending_users
  	users = Rsvp.where(event_id: self.id).map { |r| r.user_id }
  	#I should be adding this to an event object that is not an active record object
  	User.where(id: users)
  end

end
