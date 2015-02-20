class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.time :starts_at
      t.time :ends_at
      t.string :location
      t.date :event_date
      t.references :geo

      t.timestamps
    end
    add_index :events, :geo_id
  end
end
