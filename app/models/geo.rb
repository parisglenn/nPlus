class Geo < ActiveRecord::Base
	has_many :events
	belongs_to :subscription
	has_many :user_geos
	has_many :users
	has_many :user_office_hours
	has_many :round_up_user_availabilities
	has_many :round_up_matches
  attr_accessible :name, :location_type, :parent_zone, :parent_country, :parent_region, :parent_city
  default_scope order: 'geos.location_type DESC'
  validates :name, uniqueness: true

  #this is not the best implentation, just change it later
  #expecting full geo objects sent back, not ids
  def self.get_parent_geos geo_id
  	parent_geos = []
  	geo = Geo.find geo_id
  	case geo.location_type
  	when 'office'
  		parent_geos << (get_parent_geo('city', geo))
  		parent_geos << (get_parent_geo('region', parent_geos[-1]))
  		parent_geos << (get_parent_geo('country', parent_geos[-1]))
  		parent_geos << (get_parent_geo('zone', parent_geos[-1]))

  	when 'city'
  		parent_geos << (get_parent_geo('region', geo))
  		parent_geos << (get_parent_geo('country', parent_geos[-1]))
  		parent_geos << (get_parent_geo('zone', parent_geos[-1]))

  	when 'region'
  		parent_geos << (get_parent_geo('country', geo))
  		parent_geos << (get_parent_geo('zone', parent_geos[-1]))
  		
  	when 'country'
  		parent_geos << (get_parent_geo('zone', geo))	
  	end
  	parent_geos
  end

  def self.get_parent_geo geo_type, geo
  	Geo.find geo.send(('parent_'+geo_type).to_sym)
  end

	def self.get_geo_hierarchy
		geos=Geo.all
		hierarchy = {}

	end

	def self.get_offices
		self.where("parent_city is not null")
	end

  # private
  # 	def get_parent_geo geo_type, geo
  # 	  Geo.find geo.send(('parent_'+geo_type).to_sym)
  # 	end
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