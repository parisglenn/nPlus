class AddSubscribedToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :subscribed, :boolean
  end
end
