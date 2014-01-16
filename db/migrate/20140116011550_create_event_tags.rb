class CreateEventTags < ActiveRecord::Migration
  def change
    create_table :event_tags do |t|
      t.references :event
      t.references :interest

      t.timestamps
    end
    add_index :event_tags, :event_id
    add_index :event_tags, :interest_id
  end
end
