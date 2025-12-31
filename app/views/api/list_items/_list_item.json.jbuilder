json.extract! list_item, :id, :description, :done, :todo_list_id, :created_at, :updated_at
json.url api_todo_list_list_item_url(list_item.todo_list, list_item, format: :json)
