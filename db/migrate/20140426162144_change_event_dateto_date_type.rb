class ChangeEventDatetoDateType < ActiveRecord::Migration
  def change
  	remove_column :events, :event_date
    change_column :events, :event_date, :date
  end
end