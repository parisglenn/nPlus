class Office < ActiveRecord::Base
  belongs_to :geo
  has_many :user
  attr_accessible :name
end
