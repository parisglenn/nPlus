class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :start_time
      t.string :end_time
      t.string :location
      t.string :event_date
      t.references :geo, index: true

      t.timestamps
    end
  end
end
