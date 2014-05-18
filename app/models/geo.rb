class Geo < ActiveRecord::Base
	has_many :events
	belongs_to :subscription
	belongs_to :office
	has_many :user_geos
  attr_accessible :name

end
