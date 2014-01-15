class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password
      t.references :office
      t.references :team
      t.timestamps
    end
  end
end
