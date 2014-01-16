class User < ActiveRecord::Base
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
