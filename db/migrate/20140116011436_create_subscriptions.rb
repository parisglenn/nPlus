class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :geo
      t.references :interest

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :geo_id
    add_index :subscriptions, :interest_id
  end
end
