class Interests < ActiveRecord::Base
  attr_accessible :name
  belongs_to :subscription
  belongs_to :event_tag
end
