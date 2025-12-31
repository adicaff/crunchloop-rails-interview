require 'rails_helper'

RSpec.describe UpdateListItemsJob, type: :job do
  let(:todo_list) { TodoList.create!(name: "Test List") }
  let!(:item1) { todo_list.list_items.create!(description: "Item 1", done: false) }
  let!(:item2) { todo_list.list_items.create!(description: "Item 2", done: false) }

  it "updates all items in the list" do
    UpdateListItemsJob.perform_now(todo_list.id, done: true)
    
    expect(item1.reload.done).to be true
    expect(item2.reload.done).to be true
  end

  it "broadcasts updates to each item" do
    # Just verify it doesn't raise errors during execution
    expect {
      UpdateListItemsJob.perform_now(todo_list.id, done: true)
    }.not_to raise_error
  end
end
