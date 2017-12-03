Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :examples
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


end
