user = User.find_or_create_by!(username: 'test') do |u|
  u.password = 'test'
  u.password_confirmation = 'test'
end

['Setup Rails Application', 'Setup Docker PG database', 'Create todo_lists table', 'Create TodoList model',
 'Create TodoList controller'].each do |name|
  user.todo_lists.find_or_create_by!(name: name)
end
