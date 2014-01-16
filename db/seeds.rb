# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Geo.create!(:name => "New York")
Geo.create!(:name => "Boston")
Geo.create!(:name => "East Coast")
Geo.create!(:name => "London")
Geo.create!(:name => "Chicago")
Geo.create!(:name => "US")
Geo.create!(:name => "Emea")

o2 = Office.new(:name => "New York - Broadway")
o2.geo_id = 1
o2.save!
o3 = Office.create!({:name => "New York - Madison Ave", :geo_id => 1})
o2.geo_id = 1
o2.save!
o4 = Office.create!({:name => "Boston", :geo_id => 2})
o4.geo_id = 2
o4.save!
o5 = Office.create!({:name => "Chicago", :geo_id => 5})
o5.geo_id = 5
o5.save!
o6 = Office.create!({:name => "London", :geo_id => 4})
o6.geo_id = 4
o6.save!

Interest.create!(:name => "Sports")
Interest.create!(:name => "Entertainment")
Interest.create!(:name => "Music")
Interest.create!(:name => "Technology")
Interest.create!(:name => "Marketing")
Interest.create!(:name => "Charity")

Team.create!(:name => "Global Business Solutions")
Team.create!(:name => "Engineering")
Team.create!(:name => "Client Services")
Team.create!(:name => "Sales")
Team.create!(:name => "Marketing")
Team.create!(:name => "Finance")
Team.create!(:name => "Support")