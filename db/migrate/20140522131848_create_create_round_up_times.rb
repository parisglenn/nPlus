class CreateCreateRoundUpTimes < ActiveRecord::Migration
  def change
    create_table :round_up_times do |t|
      t.string :day
      t.integer :start_hour
      t.integer :end_hour
      t.boolean :deprecated

      t.timestamps
    end
  end
end
