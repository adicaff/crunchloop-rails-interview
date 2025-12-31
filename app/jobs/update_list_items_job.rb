class UpdateListItemsJob < ApplicationJob
  queue_as :default

  def perform(todo_list_id, attributes)
    todo_list = TodoList.find(todo_list_id)
    todo_list.list_items.update_all(attributes)
    
    # Reload items to get updated state before broadcasting
    todo_list.list_items.reload.each do |item|
      item.broadcast_replace_to(todo_list)
    end

    # Update the flash notice to indicate completion
    Turbo::StreamsChannel.broadcast_update_to(
      todo_list,
      target: "flash",
      partial: "layouts/flash",
      locals: { flash: { notice: "All items updated!" } }
    )
  end
end
