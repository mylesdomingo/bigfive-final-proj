json.extract! reminder, :id, :sender, :people, :message, :time, :created_at, :updated_at
json.url reminder_url(reminder, format: :json)
