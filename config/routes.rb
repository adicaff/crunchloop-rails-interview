Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :todo_lists, path: :todolists do
      resources :list_items, path: :items, only: %i[index show create update destroy]
    end
  end

  resources :todo_lists, path: :todolists do
    member do
      post :mark_all_done
    end
    resources :list_items, only: %i[create update destroy]
  end

  root 'todo_lists#index'
end
