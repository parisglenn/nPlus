class CreateRoundUpMatchUsers < ActiveRecord::Migration
  def change
    create_table :round_up_match_users do |t|
      t.references :user
      t.references :round_up_match
      t.string :rsvp
      t.boolean :open

      t.timestamps
    end
  end
end
