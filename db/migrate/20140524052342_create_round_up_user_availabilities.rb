class CreateRoundUpUserAvailabilities < ActiveRecord::Migration
  def change
    create_table :round_up_user_availabilities do |t|
      t.references :user
      t.references :round_up_time
      t.references :geo

      t.timestamps
    end
  end
end
