class Event < ActiveRecord::Base
  belongs_to :geo
  has_many :event_tags
  has_many :rsvps
  attr_accessible :ends_at, :event_date, :location, :name, :starts_at, :geo, :description, :rsvp_limit
  accepts_nested_attributes_for :event_tags

  acts_as_commentable

  default_scope order: 'event_date desc'

  validates :rsvp_limit, numericality: true

  def status=(status)
    @status = status
  end

  def status
    @status
  end

  def hosts_include? user
    host_ids = self.rsvps.select(&:host).map(&:user_id)
    host_ids.include? user.id
  end

  def attending_users
  	users = Rsvp.where(event_id: self.id).where(status: 'attending').map { |r| r.user_id }
  	#I should be adding this to an event object that is not an active record object
  	User.where(id: users)
  end

  def attendees_info
    attending = rsvps.select {|r| r.status == 'attending'}
    info = "#{attending.count} attendee"
    info += attending.count > 1 ? 's. ' : '. '
    if rsvp_limit
      info += "#{rsvp_limit - attending.count} spots left."
    else
      info += "All are welcome."
    end
  end

end
