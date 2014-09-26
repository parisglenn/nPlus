class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
  :first_name, :last_name, :admin, :event_notification_frequency, :round_up_notification_frequency,
  :team_id, :office_id, :description, :invite_code
  #belongs_to :geo, foreign_key: :office_id
  belongs_to :office, class_name: 'Geo', foreign_key: :office_id, primary_key: :id
  belongs_to :team
  has_many :rsvps
  has_many :user_office_hours
  has_many :subscriptions
  has_many :round_up_rsvp_codes
  has_many :user_geos
  has_many :round_up_matches, through: :round_up_match_users
  has_many :round_up_user_availabilities
  accepts_nested_attributes_for :team, :office#, :geo
  has_many :feedbacks
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  validates_each :invite_code, :on => :create do |record, attr, value|
    record.errors.add attr, "Please enter correct invite code" unless
      value && value == AccessCodes.find(1).code
  end

  #devise :ldap_authenticatable, :rememberable, :trackable
  #before_save :get_ldap_cn

  def get_ldap_cn
    self.name = Devise::LDAP::Adapter.get_ldap_param(self.login,"cn").first
  end

  def self.authenticate(email, password)
	  user = find_by_email(email)
	  if user && user.password == password
	    user
	  else
	    nil
	  end
	end

  def find_suggested_events
    geo_tags = UserGeo.where(user_id: self.id)
    geo_tag_ids = geo_tags.map { |g| g.geo_id }
    parent_geos = [] 
    geo_tag_ids.each do |geo_id|
      parent_geos.concat (Geo.get_parent_geos(geo_id))
    end
    parent_geo_ids = parent_geos.map(&:id)

    child_geos = [] 
    geo_tag_ids.each do |geo_id|
      child_geos.concat (Geo.get_child_geos(geo_id))
    end
    child_geo_ids = child_geos.map(&:id)

    all_geo_ids = geo_tag_ids.concat(parent_geo_ids).concat(child_geo_ids)
    # geos = Geo.where id: geo_tag_ids #all_geo_ids #remove this line
    # geo_ids = geos.map { |g| g.id } #remove this line
    subscriptions = Subscription.where(user_id: self.id)
    interests = []
    subscriptions.each { |s| interests << s.interest_id }
    event_tags = EventTag.where interest_id: interests
    event_ids = []
    event_tags.each { |et| event_ids << et.event_id }
    event_ids.uniq!
    rsvps = Rsvp.where(user_id: self.id).where(event_id: event_ids).where(status: ['attending','declined'])
    rsvps.each { |r| event_ids.delete r.event_id }
    #use all_geo_ids below, not geo_ids
    @suggested_events = Event.where(id: event_ids).where("event_date > ?", Time::now).where(geo_id: all_geo_ids)
    @suggested_events = @suggested_events.select { |se|
      se.rsvp_limit.nil? || se.rsvp_limit < se.attending_users.count
    }
    @suggested_events.each do |event|
      event.status = :undecided
    end
    @suggested_events
  end

  def find_attending_events
    rsvps = Rsvp.where(user_id: self.id).where(status: "attending")
    event_ids = []
    rsvps.each { |r| event_ids << r.event_id }
    @user_events = Event.where(id: event_ids).where('event_date > ?', Time::now)
    @user_events.each do |event|
      event.status = :attending
    end
    @user_events
  end

  def name
    if first_name and last_name
      first_name + " " + last_name 
    else
      email.split('@')[0]
    end
  end

end

    # login character varying(255) DEFAULT ''::character varying NOT NULL,
    # name character varying(255) DEFAULT ''::character varying NOT NULL,
    # remember_created_at timestamp(6) without time zone,
    # sign_in_count integer DEFAULT 0,
    # current_sign_in_at timestamp(6) without time zone,
    # last_sign_in_at timestamp(6) without time zone,
    # current_sign_in_ip character varying(255),
    # last_sign_in_ip character varying(255),
