class Interest < ActiveRecord::Base
  attr_accessible :name
  has_many :subscription
  has_many :event_tag
end
