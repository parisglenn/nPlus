class EventTags < ActiveRecord::Migration
  def change
    create_table :event_tag_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
