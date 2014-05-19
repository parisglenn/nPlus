class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :office
  belongs_to :team
  accepts_nested_attributes_for :office, :team
  attr_accessible :email, :full_name, :password, :office, :team
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email


  def self.authenticate(email, password)
	  user = find_by_email(email)
	  if user && user.password == password
	    user
	  else
	    nil
	  end
	end
end
