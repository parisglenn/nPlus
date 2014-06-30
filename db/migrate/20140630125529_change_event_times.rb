class ChangeEventTimes < ActiveRecord::Migration
  def change
  	add_column :events, :starts_at, :date
  	add_column :events, :ends_at, :date
  	remove_column :events, :start_time
  	remove_column :events, :end_time
  end
end
