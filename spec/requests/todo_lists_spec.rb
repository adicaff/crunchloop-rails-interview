require 'rails_helper'

RSpec.describe 'TodoLists', type: :request do
  let!(:todo_list) { TodoList.create!(name: 'My List') }

  describe 'GET /todolists/:id/edit' do
    it 'renders the edit form' do
      get edit_todo_list_path(todo_list)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Edit Todo List')
      expect(response.body).to include(todo_lists_path) # Cancel link
    end
  end

  describe 'GET /todolists' do
    it 'renders the index with todo list frames' do
      get todo_lists_path
      expect(response.body).to include("turbo-frame id=\"todo_list_#{todo_list.id}\"")
    end
  end

  describe 'PATCH /todolists/:id' do
    context 'with valid parameters' do
      it 'updates the todo list' do
        patch todo_list_path(todo_list), params: { todo_list: { name: 'Updated Name' } }
        expect(todo_list.reload.name).to eq('Updated Name')
        expect(response).to redirect_to(todo_lists_path)
      end

      it 'responds with turbo_stream' do
        patch todo_list_path(todo_list), params: { todo_list: { name: 'Updated Name' } }, as: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(response.body).to include('turbo-stream')
        expect(response.body).to include('Updated Name')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        patch todo_list_path(todo_list), params: { todo_list: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /todolists/:id/mark_all_done' do
    it 'updates all items via background job' do
      ActiveJob::Base.queue_adapter = :test
      post mark_all_done_todo_list_path(todo_list)
      expect(response).to redirect_to(todo_list_path(todo_list))
      expect(UpdateListItemsJob).to have_been_enqueued.with(todo_list.id, done: true)
    end

    it 'responds with turbo_stream' do
      post mark_all_done_todo_list_path(todo_list), as: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      expect(response.body).to include('turbo-stream')
    end
  end
end
