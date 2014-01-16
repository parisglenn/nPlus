class User < ActiveRecord::Base
  has_one :office
  has_one :team
  has_many :subscription
  
  accepts_nested_attributes_for :office
  accepts_nested_attributes_for :team
  
  attr_accessible :full_name, :email, :password, :office_id, :team_id
end
