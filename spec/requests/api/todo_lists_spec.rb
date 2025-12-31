require 'rails_helper'

RSpec.describe 'Api::TodoLists', type: :request do
  let!(:todo_list) { TodoList.create(name: 'First List') }

  describe 'GET /api/todolists' do
    it 'returns all todo lists' do
      get '/api/todolists', as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET /api/todolists/:id' do
    it 'returns the todo list' do
      get "/api/todolists/#{todo_list.id}", as: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(todo_list.id)
      expect(json_response['name']).to eq(todo_list.name)
      expect(json_response).to have_key('url')
    end
  end

  describe 'POST /api/todolists' do
    let(:valid_params) { { name: 'New List' } }

    it 'creates a new todo list' do
      expect {
        post '/api/todolists', params: { todo_list: valid_params }, as: :json
      }.to change(TodoList, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns error if invalid' do
      post '/api/todolists', params: { todo_list: { name: '' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/todolists/:id' do
    it 'updates the todo list' do
      patch "/api/todolists/#{todo_list.id}", params: { todo_list: { name: 'Updated Name' } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(todo_list.reload.name).to eq('Updated Name')
    end
  end

  describe 'DELETE /api/todolists/:id' do
    it 'destroys the todo list' do
      expect {
        delete "/api/todolists/#{todo_list.id}", as: :json
      }.to change(TodoList, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
