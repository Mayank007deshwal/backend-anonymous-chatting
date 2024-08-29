Rails.application.routes.draw do
  resources :chats
  resources :conversations
  post 'login', to: 'login#create'
  post 'signup', to: 'signup#create'
  post 'logout', to: 'login#logout'
  resources :posts do
    resources :messages, only: [:index, :create, :new, :show, :edit, :update, :destroy]
  end
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
