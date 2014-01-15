class Office < ActiveRecord::Base
  has_one :geo
  accepts_nested_attributes_for :geo_attributes
  attr_accessible :name, :geo_id
end
