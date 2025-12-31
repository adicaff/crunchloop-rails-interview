require 'rails_helper'

RSpec.describe 'Authorization', type: :request do
  let(:user1) { User.create!(username: 'user1', password: 'password') }
  let(:user2) { User.create!(username: 'user2', password: 'password') }
  let!(:list_user1) { TodoList.create!(name: 'User 1 List', user: user1) }

  describe 'Cross-user access' do
    before do
      sign_in user2
    end

    it 'does not show other users todo lists' do
      get todo_lists_path
      expect(response.body).not_to include('User 1 List')
    end

    it 'returns 404 for other users todo list show page' do
      expect do
        get todo_list_path(list_user1)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns 404 for other users todo list edit page' do
      expect do
        get edit_todo_list_path(list_user1)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'cannot update other users todo list' do
      expect do
        patch todo_list_path(list_user1), params: { todo_list: { name: 'Hacked' } }
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect(list_user1.reload.name).to eq('User 1 List')
    end

    it 'cannot delete other users todo list' do
      expect do
        delete todo_list_path(list_user1)
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect(TodoList.exists?(list_user1.id)).to be true
    end
  end

  describe 'API cross-user access' do
    before do
      sign_in user2
    end

    it 'does not return other users lists' do
      get '/api/todolists', as: :json
      expect(response.parsed_body).to be_empty
    end

    it 'returns 404 for other users list' do
      expect do
        get "/api/todolists/#{list_user1.id}", as: :json
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
