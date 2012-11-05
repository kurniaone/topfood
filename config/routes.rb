Topfood::Application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  resources :units
  resources :users
  resources :departments
  resources :positions
  resources :roles

  get '/branches/:id/sm' => 'branches#sm', as: 'sm_branches'
  post '/branches/:id/assign_sm' => 'branches#assign_sm', as: 'assign_sm_branches'

  resources :branches do
    collection do
      get   :sm
      post  :assign_sm
    end
  end

  get '/settings/:type' => "settings#index", as: 'settings'
  put '/settings/:type/update' => "settings#update", as: 'update_setting'
  resources :settings

  resources :purchase_orders
  resources :work_orders
  resources :employee_orders

  root :to => 'home#index'


  # API ROUTES
  namespace :api do
    resources :units
    resources :users, only: [:index, :show]
    resources :departments
    resources :positions
    resources :roles
    resources :branches

    resources :settings

    resources :purchase_orders
    resources :work_orders
    resources :employee_orders
  end
end
