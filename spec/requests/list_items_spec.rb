require 'rails_helper'

RSpec.describe 'ListItems', type: :request do
  let!(:todo_list) { TodoList.create!(name: 'My List') }
  let!(:list_item) { todo_list.list_items.create!(description: 'Item 1') }

  describe 'POST /todolists/:todo_list_id/items' do
    it 'creates a new item and redirects' do
      expect do
        post todo_list_list_items_path(todo_list), params: { list_item: { description: 'New Item' } }
      end.to change(ListItem, :count).by(1)
      expect(response).to redirect_to(todo_list_path(todo_list))
    end

    it 'creates a new item with turbo stream' do
      post todo_list_list_items_path(todo_list), params: { list_item: { description: 'New Item' } }, as: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end

  describe 'PATCH /todolists/:todo_list_id/items/:id' do
    it 'updates the item' do
      patch todo_list_list_item_path(todo_list, list_item), params: { list_item: { done: true } }
      expect(list_item.reload.done).to be true
      expect(response).to redirect_to(todo_list_path(todo_list))
    end
  end

  describe 'DELETE /todolists/:todo_list_id/items/:id' do
    it 'destroys the item' do
      expect do
        delete todo_list_list_item_path(todo_list, list_item)
      end.to change(ListItem, :count).by(-1)
      expect(response).to redirect_to(todo_list_path(todo_list))
    end
  end
end
