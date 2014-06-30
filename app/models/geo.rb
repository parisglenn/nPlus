class Geo < ActiveRecord::Base
	has_many :events
	belongs_to :subscription
	has_many :user_geos
	has_many :users
	has_many :user_office_hours
  attr_accessible :name, :location_type, :parent_zone, :parent_country, :parent_region, :parent_city
  default_scope order: 'geos.location_type DESC'
  validates :name, uniqueness: true

	def self.get_geo_hierarchy
		geos=Geo.all
		hierarchy = {}

	end

end

class GeoRelations
	@@geos = Geo.all

	def initialize name, type
		@name=name
		@type=type

	end

	def get_children

	end

	def get_ancestors

	end
end