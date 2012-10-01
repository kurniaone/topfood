Topfood::Application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  resources :master_positions
  resources :master_departments
  resources :units
  resources :users

  get '/branches/:id/sm' => 'branches#sm', as: 'sm_branches'
  post '/branches/:id/assign_sm' => 'branches#assign_sm', as: 'assign_sm_branches'

  resources :branches do
    collection do
      get   :sm
      post  :assign_sm
    end

    resources :departments
  end

  resources :departments do
    resources :positions
  end

  root :to => 'home#index'
end
