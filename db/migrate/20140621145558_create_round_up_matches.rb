class CreateRoundUpMatches < ActiveRecord::Migration
  def change
    create_table :round_up_matches do |t|
      t.references :round_up_time
      t.date :date
      t.string :location
      t.datetime :expires

      t.timestamps
    end
  end
end
