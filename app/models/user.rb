class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :admin
  belongs_to :office
  belongs_to :team
  has_many :rsvps
  has_many :subscriptions
  has_many :user_geos
  accepts_nested_attributes_for :office, :team
  attr_accessible :email, :full_name, :password, :office, :team,
                  :login, 
                  :password, 
                  :password_confirmation, 
                  :remember_me
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

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
    geos = Geo.where id: geo_tag_ids
    geo_ids = geos.map { |g| g.id }
    subscriptions = Subscription.where(user_id: self.id)
    interests = []
    subscriptions.each { |s| interests << s.interest_id }
    event_tags = EventTag.where interest_id: interests
    event_ids = []
    event_tags.each { |et| event_ids << et.event_id }
    event_ids.uniq!
    rsvps = Rsvp.where(user_id: self.id).where(event_id: event_ids).where(status: ['attending','declined'])
    rsvps.each { |r| event_ids.delete r.event_id }
    @suggested_events = Event.where(id: event_ids).where("event_date > ?", Time::now).where(geo_id: geo_ids)
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

end

    # login character varying(255) DEFAULT ''::character varying NOT NULL,
    # name character varying(255) DEFAULT ''::character varying NOT NULL,
    # remember_created_at timestamp(6) without time zone,
    # sign_in_count integer DEFAULT 0,
    # current_sign_in_at timestamp(6) without time zone,
    # last_sign_in_at timestamp(6) without time zone,
    # current_sign_in_ip character varying(255),
    # last_sign_in_ip character varying(255),
