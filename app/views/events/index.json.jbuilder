json.array!(@events) do |event|
  json.extract! event, :id, :name, :start_time, :end_time, :location, :event_date, :geo_id
  json.url event_url(event, format: :json)
end
