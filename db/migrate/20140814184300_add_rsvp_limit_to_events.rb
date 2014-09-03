class AddRsvpLimitToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :rsvp_limit, :integer
  end
end
