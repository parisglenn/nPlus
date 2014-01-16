class Office < ActiveRecord::Base
  has_one :geo
  belongs_to :user
  accepts_nested_attributes_for :geo
  attr_accessible :name, :geo_id
end
