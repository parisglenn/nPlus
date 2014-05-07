class CreateUserGeos < ActiveRecord::Migration
  def change
    create_table :user_geos do |t|
      t.integer :user_id
      t.integer :geo_id
      t.boolean :subscribed

      t.timestamps
    end
  end
end
