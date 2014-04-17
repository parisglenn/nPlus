class Geo < ActiveRecord::Base
	has_many :events
	belongs_to :subscription
	belongs_to :office
  attr_accessible :name

end
