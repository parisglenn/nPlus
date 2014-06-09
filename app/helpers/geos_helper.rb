module GeosHelper
	def generate_location_type_dropdown
		[['Office','office'],['City','city'],['Region','region'],['Country','country'],['Global Zone','global_zone']]	
	end
	
	def generate_parent_city_dropdown
		city_dropdown = [[nil, nil]]
		cities = Geo.where(location_type: 'city')
		cities_array = cities.map do |city|
			[city.name, city.id]
		end
		city_dropdown.concat  cities_array
	end
	def generate_parent_region_dropdown
		region_dropdown = [[nil, nil]]
		regions = Geo.where(location_type: 'region')
		regions_array = regions.map do |region|
			[region.name, region.id]
		end
		region_dropdown.concat regions_array
	end
	def generate_parent_country_dropdown
		country_dropdown = [[nil, nil]]
		countries = Geo.where(location_type: 'country')
		countries_array = countries.map do |country|
			[country.name, country.id]
		end
		country_dropdown.concat countries_array
	end
	def generate_parent_zone_dropdown
		zone_dropdown = [[nil, nil]]
		zones = Geo.where(location_type: 'global_zone')
		zones_array = zones.map do |zone|
			[zone.name, zone.id]
		end
		zone_dropdown.concat zones_array
	end
end
