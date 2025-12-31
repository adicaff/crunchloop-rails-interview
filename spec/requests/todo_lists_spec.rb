require 'rails_helper'

RSpec.describe 'TodoLists', type: :request do
  let!(:todo_list) { TodoList.create!(name: 'My List') }

  describe 'GET /todolists' do
    it 'returns a successful response' do
      get todo_lists_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all todo lists' do
      another_list = TodoList.create!(name: 'Another List')
      get todo_lists_path
      expect(response.body).to include('My List')
      expect(response.body).to include('Another List')
    end
  end

  describe 'GET /todolists/:id' do
    it 'returns a successful response' do
      get todo_list_path(todo_list)
      expect(response).to have_http_status(:success)
    end

    it 'displays the todo list name' do
      get todo_list_path(todo_list)
      expect(response.body).to include('My List')
    end

    it 'displays list items' do
      list_item = todo_list.list_items.create!(description: 'Test item')
      get todo_list_path(todo_list)
      expect(response.body).to include('Test item')
    end
  end

  describe 'GET /todolists/new' do
    it 'returns a successful response' do
      get new_todo_list_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /todolists' do
    context 'with valid parameters' do
      it 'creates a new todo list' do
        expect do
          post todo_lists_path, params: { todo_list: { name: 'New List' } }
        end.to change(TodoList, :count).by(1)
      end

      it 'redirects to the todo lists index' do
        post todo_lists_path, params: { todo_list: { name: 'New List' } }
        expect(response).to redirect_to(todo_lists_path)
      end

      it 'responds with turbo_stream' do
        post todo_lists_path, params: { todo_list: { name: 'New List' } }, as: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new todo list' do
        expect do
          post todo_lists_path, params: { todo_list: { name: '' } }
        end.not_to change(TodoList, :count)
      end

      it 'renders the new template with unprocessable_entity status' do
        post todo_lists_path, params: { todo_list: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /todolists/:id' do
    context 'with valid parameters' do
      it 'updates the todo list' do
        patch todo_list_path(todo_list), params: { todo_list: { name: 'Updated Name' } }
        todo_list.reload
        expect(todo_list.name).to eq('Updated Name')
      end

      it 'redirects to the todo lists index' do
        patch todo_list_path(todo_list), params: { todo_list: { name: 'Updated Name' } }
        expect(response).to redirect_to(todo_lists_path)
      end

      it 'responds with turbo_stream' do
        patch todo_list_path(todo_list), params: { todo_list: { name: 'Updated Name' } }, as: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the todo list' do
        original_name = todo_list.name
        patch todo_list_path(todo_list), params: { todo_list: { name: '' } }
        todo_list.reload
        expect(todo_list.name).to eq(original_name)
      end

      it 'renders the edit template with unprocessable_entity status' do
        patch todo_list_path(todo_list), params: { todo_list: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /todolists/:id' do
    it 'destroys the todo list' do
      expect do
        delete todo_list_path(todo_list)
      end.to change(TodoList, :count).by(-1)
    end

    it 'redirects to the todo lists index' do
      delete todo_list_path(todo_list)
      expect(response).to redirect_to(todo_lists_path)
    end

    it 'responds with turbo_stream' do
      delete todo_list_path(todo_list), as: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
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
