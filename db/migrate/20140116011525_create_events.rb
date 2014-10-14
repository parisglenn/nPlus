class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.time :start_time
      t.time :end_time
      t.string :location
      t.date :event_date
      t.references :geo

      t.timestamps
    end
    add_index :events, :geo_id
  end
end
