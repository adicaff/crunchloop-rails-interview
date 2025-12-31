require 'rails_helper'

RSpec.describe TodoListsController, type: :controller do
  let(:user) { User.create!(username: 'testuser', password: 'password') }
  let!(:todo_list) { TodoList.create!(name: 'Test List', user: user) }

  before do
    sign_in user
  end

  describe 'POST #mark_all_done' do
    it 'enqueues UpdateListItemsJob' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        post :mark_all_done, params: { id: todo_list.id }
      end.to have_enqueued_job(UpdateListItemsJob).with(todo_list.id, done: true)
    end

    it 'redirects to the todo list' do
      post :mark_all_done, params: { id: todo_list.id }
      expect(response).to redirect_to(todo_list)
    end
  end
end
