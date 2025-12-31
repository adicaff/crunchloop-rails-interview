class UpdateListItemsJob < ApplicationJob
  queue_as :default

  def perform(todo_list_id, attributes)
    todo_list = TodoList.find(todo_list_id)
    # rubocop:disable Rails/SkipsModelValidations
    todo_list.list_items.update_all(attributes.merge(updated_at: Time.current))
    # rubocop:enable Rails/SkipsModelValidations

    # Broadcast a single update to the list instead of N+1 broadcasts
    broadcast_list_update(todo_list)

    # Update the flash notice to indicate completion
    broadcast_flash_update(todo_list)
  end

  private

  def broadcast_list_update(todo_list)
    Turbo::StreamsChannel.broadcast_replace_to(
      todo_list,
      target: 'list_items',
      partial: 'todo_lists/list_items',
      locals: { todo_list: todo_list }
    )
  end

  def broadcast_flash_update(todo_list)
    Turbo::StreamsChannel.broadcast_update_to(
      todo_list,
      target: 'flash',
      partial: 'layouts/flash',
      locals: { flash: { notice: I18n.t('todo_lists.all_updated') } }
    )
  end
end
