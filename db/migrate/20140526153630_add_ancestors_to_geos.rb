class AddAncestorsToGeos < ActiveRecord::Migration
  def change
  	add_column :geos, :location_type, :string
  	add_column :geos, :parent_city, :integer
  	add_column :geos, :parent_region, :integer
  	add_column :geos, :parent_country, :integer
  	add_column :geos, :parent_zone, :integer
  end
end
