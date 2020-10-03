Rails.application.routes.draw do
  resources :save_files
  resources :games
  devise_for :users

  namespace :api do
    namespace :v1 do
      get '/profile', to: 'users#profile', as: 'user_profile'

      get '/games/latest', to: 'games#latest', as: 'game_latest'
      get '/games/lookup', to: 'games#lookup', as: 'game_lookup'
      resources :games do
        get '/save_files/lookup', to: 'save_files#lookup', as: 'save_file_lookup'
        resources :save_files
      end
    end
  end

  get '/profile', to: 'users#profile', as: 'user_profile'
  get '/profile/edit', to: 'users#edit', as: 'edit_user_profile'
  patch '/profile/edit', to: 'users#update', as: 'update_user_profile'
  put '/profile/edit', to: 'users#update'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "base#index"
end
