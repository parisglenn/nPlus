class ChangeRoundUpTimeStartToTime < ActiveRecord::Migration
  def change
  	change_column :round_up_times, :start_hour, :time
  	change_column :round_up_times, :end_hour, :time
  end
end
