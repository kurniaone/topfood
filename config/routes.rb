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

  match '/purchase_orders/:id/approve'  => "purchase_orders#approve",   as: 'approve_purchase_orders',  via: [:get, :post]
  match '/work_orders/:id/approve'      => "work_orders#approve",       as: 'approve_work_orders',      via: [:get, :post]
  match '/employee_orders/:id/approve'  => "employee_orders#approve",   as: 'approve_employee_orders',  via: [:get, :post]

  get '/purchase_orders/:id/received'   => "purchase_orders#received",  as: 'received_purchase_orders'
  get '/work_orders/:id/received'       => "work_orders#received",      as: 'received_work_orders'
  get '/employee_orders/:id/received'   => "employee_orders#received",  as: 'received_employee_orders'

  get '/purchase_orders/:id/done'       => "purchase_orders#done",      as: 'done_purchase_orders'
  get '/work_orders/:id/done'           => "work_orders#done",          as: 'done_work_orders'
  get '/employee_orders/:id/done'       => "employee_orders#done",      as: 'done_employee_orders'

  resources :purchase_orders do
    collection do
      :approve
    end
  end
  resources :work_orders do
    collection do
      :approve
    end
  end
  resources :employee_orders do
    collection do
      :approve
    end
  end

  root :to => 'home#index'


  # API ROUTES
  namespace :api do
    devise_for :users

    put "purchase_orders/:id/approve" => "purchase_orders#approve", as: "approve_api_purchase_orders"
    put "work_orders/:id/approve"     => "work_orders#approve",     as: "approve_api_work_orders"
    put "employee_orders/:id/approve" => "employee_orders#approve", as: "approve_api_employee_orders"
    get "sync"                        => "sync#index",              as: "sync"
    get "users/:id/branches"          => "users#branches",          as: "user_branches"

    resources :units
    resources :users, only: [:index, :show]
    resources :departments
    resources :positions
    resources :roles
    resources :branches

    resources :purchase_orders do
      collection do
        post :sync
        get  :to_sync
      end
    end
    resources :work_orders do
      collection do
        post :sync
        get  :to_sync
      end
    end
    resources :employee_orders do
      collection do
        post :sync
        get  :to_sync
      end
    end
  end
end
