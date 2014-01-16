class User < ActiveRecord::Base
  belongs_to :office
  belongs_to :team
  attr_accessible :email, :full_name, :password, :office, :team
end
