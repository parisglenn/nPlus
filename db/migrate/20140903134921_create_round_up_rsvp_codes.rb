class CreateRoundUpRsvpCodes < ActiveRecord::Migration
  def change
    create_table :round_up_rsvp_codes do |t|
      t.string :code
      t.integer :user_id
      t.integer :round_up_match_id
      t.string :action

      t.timestamps
    end
  end
end
