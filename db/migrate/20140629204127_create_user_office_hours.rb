class CreateUserOfficeHours < ActiveRecord::Migration
  def change
    create_table :user_office_hours do |t|
      t.integer :user_id
      t.integer :geo_id
      t.string :day_of_week
      t.time :starts_at
      t.time :ends_at

      t.timestamps
    end
  end
end
