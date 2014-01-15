json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :user_id, :geo_id, :interest_id
  json.url subscription_url(subscription, format: :json)
end
