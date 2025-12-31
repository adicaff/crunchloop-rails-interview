Rails.application.routes.draw do
  devise_for :users, skip: [:passwords]
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
  
  # Catch-all route: redirect unmatched routes to login
  # This must be last to only catch routes that don't match anything above
  match '*path', to: redirect('/users/sign_in'), via: :all, constraints: lambda { |req|
    # Exclude Rails internal paths and static assets
    !req.path.start_with?('/rails') && 
    !req.path.start_with?('/assets') &&
    !req.path.start_with?('/api')
  }
end
