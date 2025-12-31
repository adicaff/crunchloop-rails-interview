Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, path: :todolists do
      resources :list_items, path: :items, only: %i[index show create update destroy]
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
