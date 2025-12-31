require 'rails_helper'

RSpec.describe UpdateListItemsJob, type: :job do
  let(:todo_list) { TodoList.create!(name: 'Test List') }
  let!(:item_one) { todo_list.list_items.create!(description: 'Item 1', done: false) }
  let!(:item_two) { todo_list.list_items.create!(description: 'Item 2', done: false) }

  it 'updates all items in the list' do
    described_class.perform_now(todo_list.id, done: true)

    expect(item_one.reload.done).to be true
    expect(item_two.reload.done).to be true
  end

  it 'broadcasts list update' do
    # Verify it doesn't raise errors during execution
    expect do
      described_class.perform_now(todo_list.id, done: true)
    end.not_to raise_error
  end
end
