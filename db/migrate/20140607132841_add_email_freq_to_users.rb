class AddEmailFreqToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :event_notification_frequency, :string
  	add_column :users, :round_up_notification_frequency, :string
  end
end