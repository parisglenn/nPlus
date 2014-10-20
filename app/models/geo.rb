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
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :location_type

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

  def self.get_child_geos geo_id
  	child_geos = []
  	geo = Geo.find geo_id
  	case geo.location_type
  	when 'city'
  		child_geos << get_child_geos_for('city', [geo])
  	when 'region'
  		child_geos << get_child_geos_for('region', [geo])
  		child_geos << get_child_geos_for('city', child_geos[-1])
  	when 'country'
  		child_geos << get_child_geos_for('country', [geo])
  		child_geos << get_child_geos_for('region', child_geos[-1])
  		child_geos << get_child_geos_for('city', child_geos[-1])
  	when 'global_zone'
  		child_geos << get_child_geos_for('global_zone', [geo])
  		child_geos << get_child_geos_for('country', child_geos[-1])
  		child_geos << get_child_geos_for('region', child_geos[-1])
  		child_geos << get_child_geos_for('city', child_geos[-1])
  	end

  	child_geos.flatten
  end

  def self.get_parent_geo_types
  	{'city' => :parent_city, 'region' => :parent_region, 'country' => :parent_country,
  		'global_zone' => :parent_zone}
  end

  def self.get_child_geos_for geo_type, geos
  	children = []
  	geos.each do |geo|
		children << Geo.where((get_parent_geo_types[geo_type]) => geo.id)#.
		#where(location_type: get_child_geo_types[geo_type])
  	end
  	children.flatten
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