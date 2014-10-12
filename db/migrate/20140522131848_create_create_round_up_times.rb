class CreateCreateRoundUpTimes < ActiveRecord::Migration
  def change
    create_table :round_up_times do |t|
      t.string :day
      t.time :start_hour
      t.time :end_hour
      t.boolean :deprecated

      t.timestamps
    end
  end
end
