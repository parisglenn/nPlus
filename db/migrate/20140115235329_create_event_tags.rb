class CreateEventTags < ActiveRecord::Migration
  def change
    create_table :event_tags do |t|
      t.references :event, index: true
      t.references :interest, index: true

      t.timestamps
    end
  end
end
