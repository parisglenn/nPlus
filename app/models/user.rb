class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :office
  belongs_to :team
  has_many :rsvps
  has_many :subscriptions
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

end

    # login character varying(255) DEFAULT ''::character varying NOT NULL,
    # name character varying(255) DEFAULT ''::character varying NOT NULL,
    # remember_created_at timestamp(6) without time zone,
    # sign_in_count integer DEFAULT 0,
    # current_sign_in_at timestamp(6) without time zone,
    # last_sign_in_at timestamp(6) without time zone,
    # current_sign_in_ip character varying(255),
    # last_sign_in_ip character varying(255),
