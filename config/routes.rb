Topfood::Application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  resources :units
  resources :users
  resources :departments
  resources :positions
  resources :managements

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

  root :to => 'home#index'
end
