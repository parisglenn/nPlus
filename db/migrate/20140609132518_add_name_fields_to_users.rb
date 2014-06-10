class AddNameFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :office_id, :integer
  	add_column :users, :team_id, :integer
  end
end
