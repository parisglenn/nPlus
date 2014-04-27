class CreateRsvpTable < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.boolean :host
      t.string :status
      t.references :user
      t.references :event

      t.timestamps
    end
    add_index :rsvps, :event_id
    add_index :rsvps, :user_id
  end
end