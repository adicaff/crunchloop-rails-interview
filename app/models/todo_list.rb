class TodoList < ApplicationRecord
  has_many :list_items, dependent: :destroy

  validates :name, presence: true

  after_create_commit { broadcast_prepend_to 'todo_lists' }
  after_update_commit { broadcast_replace_to 'todo_lists' }
  after_destroy_commit { broadcast_remove_to 'todo_lists' }
end
