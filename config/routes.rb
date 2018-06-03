Rails.application.routes.draw do
  scope module: 'api' do
    namespace :v1 do
      resources :children
      resources :tasks
      resources :chores
      resources :users

      get :token, controller: 'application'
    end
    namespace :v2 do
      resources :children
      resources :tasks
      resources :chores
      resources :users

      get :token, controller: 'application'
    end
  end
end