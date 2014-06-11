class Office < ActiveRecord::Base
  belongs_to :geo
  has_many :users
  accepts_nested_attributes_for :geo
  attr_accessible :name, :geo_id
end
