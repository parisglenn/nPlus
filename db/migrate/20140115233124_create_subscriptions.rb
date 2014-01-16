class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.references :geo, index: true
      t.references :interest, index: true

      t.timestamps
    end
  end
end
