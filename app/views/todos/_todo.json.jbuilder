json.extract! todo, :id, :name, :sender, :people, :message, :time, :created_at, :updated_at
json.url todo_url(todo, format: :json)
