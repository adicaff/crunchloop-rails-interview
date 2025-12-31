require 'rails_helper'

RSpec.describe 'Api::ListItems', type: :request do
  let!(:todo_list) { TodoList.create(name: 'Work') }
  let!(:list_item) { ListItem.create(description: 'Task 1', todo_list: todo_list) }

  describe 'GET /api/todolists/:todo_list_id/items' do
    it 'returns all items for the list' do
      get "/api/todolists/#{todo_list.id}/items", as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET /api/todolists/:todo_list_id/items/:id' do
    it 'returns the list item' do
      get "/api/todolists/#{todo_list.id}/items/#{list_item.id}", as: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(list_item.id)
      expect(json_response['description']).to eq(list_item.description)
      expect(json_response).to have_key('url')
    end
  end

  describe 'POST /api/todolists/:todo_list_id/items' do
    let(:valid_params) { { description: 'New Task' } }

    it 'creates a new list item' do
      expect {
        post "/api/todolists/#{todo_list.id}/items", params: { list_item: valid_params }, as: :json
      }.to change(ListItem, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns error if invalid' do
      post "/api/todolists/#{todo_list.id}/items", params: { list_item: { description: '' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/todolists/:todo_list_id/items/:id' do
    it 'updates the list item' do
      patch "/api/todolists/#{todo_list.id}/items/#{list_item.id}", params: { list_item: { done: true } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(list_item.reload.done).to be(true)
    end
  end

  describe 'DELETE /api/todolists/:todo_list_id/items/:id' do
    it 'destroys the list item' do
      expect {
        delete "/api/todolists/#{todo_list.id}/items/#{list_item.id}", as: :json
      }.to change(ListItem, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
