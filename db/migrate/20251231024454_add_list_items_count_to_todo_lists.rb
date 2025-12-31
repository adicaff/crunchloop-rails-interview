class AddListItemsCountToTodoLists < ActiveRecord::Migration[7.0]
  def change
    add_column :todo_lists, :list_items_count, :integer, default: 0, null: false

    # Reset column information and populate counter cache for existing records
    reversible do |dir|
      dir.up do
        TodoList.reset_column_information
        TodoList.find_each do |todo_list|
          TodoList.reset_counters(todo_list.id, :list_items)
        end
      end
    end
  end
end
