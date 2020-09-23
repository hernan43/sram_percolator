Rails.application.routes.draw do
  resources :save_files
  resources :games
  devise_for :users

  namespace :api do
    namespace :v1 do
      get '/profile', to: 'users#profile', as: 'user_profile'

      resources :games
    end
  end

  get '/profile', to: 'users#profile', as: 'user_profile'
  get '/profile/edit', to: 'users#edit', as: 'edit_user_profile'
  patch '/profile/edit', to: 'users#update', as: 'update_user_profile'
  put '/profile/edit', to: 'users#update'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "base#index"
end
