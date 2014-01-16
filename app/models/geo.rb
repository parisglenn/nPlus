class Geo < ActiveRecord::Base
	has_many :event
	has_many :subscription
	has_many :office
  attr_accessible :name

end
