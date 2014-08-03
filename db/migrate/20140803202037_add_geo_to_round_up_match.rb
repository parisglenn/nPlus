class AddGeoToRoundUpMatch < ActiveRecord::Migration
  def change
  	add_column :round_up_matches, :geo_id, :integer
  end
end
