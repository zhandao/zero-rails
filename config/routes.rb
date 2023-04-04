require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user_name, password|
  user_name == Keys.admin.user_name && password == Keys.admin.password
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ActiveAdmin.routes(self)

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # /api/v1/nested/:nested_id/routes/:id
      # resources :nested do
      #   resources :routes
      # end

      resources :goods do
        post 'change_onsale', on: :member
      end

      resources :stores

      resources :categories, except: [:show] do
        get 'list', to: 'categories#nested_list', on: :collection
      end

      resources :inventories, only: [:index]


      get 'u/:name', to: 'users#show_via_name'
      resources :users do
        post 'login', on: :collection
        member do
          get  'roles'
          get  'permissions'
          post 'roles/modify',       to: 'users#roles_modify'
          post 'permissions/modify', to: 'users#permissions_modify'
        end
      end


      resources :roles do
        member do
          get 'permissions'
          post 'permissions/modify', to: 'roles#permissions_modify'
        end
      end

      resources :permissions
    end
  end

  get 'apidoc', to: 'home#apidoc'
  get 'open_api/:doc', to: 'home#open_api'
  match '*path', via: :all, to: 'home#error_404'
end
