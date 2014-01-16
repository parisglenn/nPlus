class Office < ActiveRecord::Base
  belongs_to :geo
  attr_accessible :name
end
